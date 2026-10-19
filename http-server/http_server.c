#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
#include <sys/wait.h>

#define PORT 1111
#define BUFFER_SIZE 1024

int server_socket;      // Для сокета
volatile sig_atomic_t server_running = 1; // Для отслеживания состояния сервера

// Обработка сигнала для очистки завершенных процессов
void handle_sigchld(int sig) {
    (void)sig;
    while (waitpid(-1, NULL, WNOHANG) > 0);
}

// Обработка сигнала для корректного завершения сервера
void handle_sigint(int sig) {
    (void)sig;
    printf("\nShutting down server...\n");
    close(server_socket);
    server_running = 0;
}

// Функция для отправки HTTP ответа
void send_http_response(int client_socket, const char *header, const char *file_path, int is_head) {
    char buffer[BUFFER_SIZE];
    int file_fd;        // Дескриптор для чтения файла (index)
    ssize_t bytes_read; // Для хранения количества байт, прочитанных из файла

    // Отправка HTTP-заголовка
    send(client_socket, header, strlen(header), 0);

    // Если это запрос HEAD, завершение
    if (is_head) {
        return;
    }

    // Открываем файл index 
    file_fd = open(file_path, O_RDONLY);
    if (file_fd < 0) {
        perror("open");
        close(client_socket);
        return;
    }

    // Чтение содержимого файла и отправка
    while ((bytes_read = read(file_fd, buffer, BUFFER_SIZE)) > 0) {
        send(client_socket, buffer, bytes_read, 0);
    }

    close(file_fd);
}

// Обработка запроса 
void handle_client(int client_socket) {
    char buffer[BUFFER_SIZE];
    char method[16] = {0};
    char path[256] = {0};
    ssize_t bytes_read;

    // Чтение запроса из сокета
    bytes_read = recv(client_socket, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_read < 0) {
        perror("recv");
        close(client_socket);
        exit(EXIT_FAILURE);
    }

    buffer[bytes_read] = '\0';

    // Извлечение метода и пути
    sscanf(buffer, "%15s %255s", method, path);

    // Проверка метода и пути
    if (strcmp(method, "GET") == 0 && strcmp(path, "/") == 0) {
        // GET / — отдача index.htm с телом
        const char *response_header = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n";
        send_http_response(client_socket, response_header, "index.htm", 0);
    } else if (strcmp(method, "HEAD") == 0 && strcmp(path, "/") == 0) {
        // HEAD / —  только заголовка
        const char *response_header = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n";
        send_http_response(client_socket, response_header, "index.htm", 1);
    } else {
        // Всё остальное — 404
        const char *response = "HTTP/1.1 404 Not Found\r\nContent-Type: text/html\r\n\r\n"
                               "<html><body><h1>404 Not Found</h1></body></html>";
        send(client_socket, response, strlen(response), 0);
    }

    close(client_socket);
}

int main() {
    // Инфорация об адресе, адрес сервера, адрес клиента
    struct sockaddr_in server_addr, client_addr;
    // Длина адреса клиента
    socklen_t client_addr_len = sizeof(client_addr);
    // Идентификатор для дочернего процесса
    pid_t pid;

    // Установка обработчиков сигналов
    signal(SIGCHLD, handle_sigchld);
    signal(SIGINT, handle_sigint); 

    // Создание сокета (IPv4, потоковый)
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    int opt = 1;
    if (setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) < 0) {
        perror("setsockopt");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    // Настройка адреса сервера
    memset(&server_addr, 0, sizeof(server_addr)); // очищение адреса
    server_addr.sin_family = AF_INET; //установка семьи адресов
    server_addr.sin_addr.s_addr = INADDR_ANY; // на всех доступных интерфейсах
    server_addr.sin_port = htons(PORT); 

    // Привязка сокета к адресу
    if (bind(server_socket, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("bind");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    // Запуск сервера и ожидание подключения 
    if (listen(server_socket, 10) < 0) {
        perror("listen");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    printf("Server is running on port %d...\n", PORT);

    // Основной цикл работы сервера
    while (server_running) {
        // Ожидание подключения
        int client_socket = accept(server_socket, (struct sockaddr*)&client_addr, &client_addr_len);
        if (client_socket < 0) {
            perror("accept");
            continue;
        }

        // Создание дочернего процеса для обработки клиента
        pid = fork();
        if (pid < 0) {
            perror("fork");
            close(client_socket);
            continue;
        }

        if (pid == 0) {  // Дочерний процесс
            close(server_socket);
            handle_client(client_socket);
            exit(EXIT_SUCCESS);
        } else {         // Родительский 
            close(client_socket);
        }
    }

    close(server_socket);
    return 0;
}
