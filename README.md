# HTTP Server in C & Bash File-Copy Script

Два проекта по системному программированию и автоматизации в Linux:
**HTTP-сервер на C** (сокеты Беркли, `fork`, сигналы, POSIX I/O)
и **Bash-скрипт** копирования файлов с обработкой конфликтов имён.

## Содержание

| Проект | Что внутри | Стек |
|---|---|---|
| [http-server](http-server/) | HTTP-сервер: GET/HEAD, `fork` на запрос, `SIGCHLD`/`SIGINT`, POSIX I/O | C, POSIX, sockets |
| [bash-script](bash-script/) | Копирование файлов с обработкой одинаковых имён, `--help`, логирование | Bash |

## Главное

### HTTP Server (C)
- Методы **GET** и **HEAD**
- **Многопроцессная модель** — `fork()` на каждый запрос
- **Сигналы** — `SIGCHLD` (уборка зомби), `SIGINT` (graceful shutdown)
- **POSIX I/O** — `open` / `read` / `send`
- Отдача статики (`index.htm`)

**Запуск:**
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
