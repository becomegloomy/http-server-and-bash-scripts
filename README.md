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
```

### Bash Script
- Проверка аргументов, `--help`
- Создание каталога назначения (`mkdir -p`)
- Обработка конфликтов имён (`file.txt` → `file.txt.1`)
- Логирование в `report.txt`

**Запуск:**
```bash
cd bash-script
./script.sh --help
./script.sh ./src ./dst
```

## Стек
`C`, `POSIX`, `sockets`, `fork`, `signals`, `Bash`, `Linux`

## Структура
```
.
├── http-server/      # HTTP-сервер на C
│   ├── src/
│   ├── include/
│   ├── www/
│   ├── tests/
│   ├── Makefile
│   └── README.md
└── bash-script/      # Bash-скрипт
    ├── script.sh
    ├── tests/
    └── README.md
```

## Чему научился
- Сокеты: `socket` / `bind` / `listen` / `accept`
- `fork()`: многопроцессность, зомби-процессы
- Сигналы: `SIGCHLD`, `SIGINT`
- POSIX I/O vs stdio
- HTTP/1.1: запрос, ответ, заголовки
- Bash: аргументы, `--help`, функции, параметрические расширения
