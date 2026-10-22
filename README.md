# HTTP Server in C & Bash File-Copy Script

Два проекта по системному программированию и автоматизации в Linux: HTTP-сервер на C и Bash-скрипт для копирования файлов с обработкой конфликтов имён.

## Содержание

| Проект | Содержание | Стек |
|---|---|---|
| [http-server](http-server/) | HTTP-сервер: отдаёт `index.htm` по `GET /`, заголовок по `HEAD /`, `404` на всё остальное. Каждый клиент — отдельный процесс (`fork`), корректное завершение по `SIGINT`, зомби-процессы убираются по `SIGCHLD` | C, POSIX, sockets |
| [bash-script](bash-script/) | Копирование файлов из одного каталога в другой с авто-переименованием конфликтов (`a.txt` → `a.1.txt`), `--help`, лог действий в `report.txt` | Bash |

## Запуск

### HTTP Server
```bash
cd http-server
make
./http_server
```

**Проверка:**
```bash
curl -v http://localhost:1111/        # GET
curl -I http://localhost:1111/        # HEAD
curl -v http://localhost:1111/nope    # 404
```

**Тестирование:**
```bash
cd http-server
./tests/run_all.sh
```

Тесты (`tests/test_get.sh`, `test_head.sh`, `test_404.sh`) поднимают сервер, делают запрос через `curl` и проверяют код ответа (`200`, `200`, `404`).

### Bash Script
```bash
cd bash-script
./script.sh --help
./script.sh ./src ./dst
```

**Тестирование:**
```bash
cd bash-script
./tests/run_all.sh
```

Тесты (`tests/test_help.sh`, `test_args.sh`, `test_copy.sh`) проверяют справку, обработку неверного числа аргументов и фактическое копирование файлов.
