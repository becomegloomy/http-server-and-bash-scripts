# HTTP Server in C & Bash File-Copy Script

Два проекта по системному программированию и автоматизации в Linux.

## Содержание

| Проект | Содержание | Стек |
|---|---|---|
| [http-server](http-server/) | HTTP-сервер: GET/HEAD, `fork` на запрос, `SIGCHLD`/`SIGINT`, POSIX I/O, отдача статики | C, POSIX, sockets |
| [bash-script](bash-script/) | Копирование файлов с обработкой конфликтов имён, `--help`, логирование | Bash |

## Запуск

### HTTP Server
```bash
cd http-server
make
./http_server 1111 ./www
```

**Проверка:**
```bash
curl -v http://localhost:1111/
curl -I http://localhost:1111/        # HEAD
curl -v http://localhost:1111/nope    # 404
```

### Bash Script
```bash
cd bash-script
./script.sh --help
./script.sh ./src ./dst
```
