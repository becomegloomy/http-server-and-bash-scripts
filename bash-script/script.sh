#!/bin/bash

# Функция для вывода --help
usage() { 
    echo " Укажите путь/имя каталога, откуда копировать файлы, и куда в формате:"
    echo " ./script.sh <каталог1> <каталог2>"
    echo " Второй аргумент опциональный, если его пропустить, будет создан новый каталог с copy в названии""
    echo " Если каталога указанного во втором аргументе не существует, будет создан новый каталог с указанным именем"
}

# Проверка на наличие аргумента --help
if [[ "$1" == "--help" ]]; then
  usage
  exit 0
fi

# Проверка на количество аргументов
# # - кол-во аргументов, lt - меньше, gt - больше
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Ошибка: некорректное количество аргументов"
  usage
  exit 1
fi

# Переменная для первого аргумента
SRC_DIR=$1

# Проверка, существует ли каталог, откуда копировать
if [ ! -d "$SRC_DIR" ]; then
  echo "Ошибка: '$SRC_DIR' не существует."
  exit 1
fi

# Если второй аргумент не указан, создаем новый каталог автоматически
if [ -z "$2" ]; then
  DST_DIR="${SRC_DIR}_copy"
else
  DST_DIR=$2
  
  # Проверка, не является аргумент файлом
  if [ -e "$DST_DIR" ] && [ ! -d "$DST_DIR" ]; then
    echo "Ошибка: '$DST_DIR' является файлом."
    exit 1
  fi
fi

REPORT_FILE="report.txt"

# Создание каталога назначения, если он не существует
if [ ! -d "$DST_DIR" ]; then
  echo "Создание нового каталога '$DST_DIR'."
  # p - родительский каталог, если указан путь
  mkdir -p "$DST_DIR"
fi

# Очистка файла отчета
> "$REPORT_FILE"

# Функция для файлов с одинаковыми именами
get_new_filename() {
  local filename="$1"
  local base="${filename%.*}"   # Имя файла без расширения
  local ext="${filename##*.}"   # Расширение файла

  if [ "$base" = "$filename" ]; then
    echo "${base}.1"
  else
    echo "${base}.1.${ext}"
  fi
}

# Проход по всем файлам в исходном каталоге
for file in "$SRC_DIR"/*; do
# f - файл
  if [ -f "$file" ]; then
    # Копирование названия файла
    base_name=$(basename "$file")
    # Создание нового пути к указанному каталогу
    dest_file="$DST_DIR/$base_name"

    # Проверка на одинаковые файлы
    if [ -e "$dest_file" ]; then
      dest_file="$DST_DIR/$(get_new_filename "$base_name")"
    fi

    # Копирование файла
    cp "$file" "$dest_file"

    # Вывод действия в консоль и файл отчета
    echo "Copied '$file' to '$dest_file'"
    echo "Copied '$file' to '$dest_file'" >> "$REPORT_FILE"
  fi
done

echo "Операция выполнена. Протокол проведенных действий сохранен в файл '$REPORT_FILE'."
