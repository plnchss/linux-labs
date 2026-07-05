#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Использование: $0 <путь_к_директории> <путь_к_папке_резервного_копирования>"
    exit 1
fi

SOURCE="$1"
BACKUP_DIR="$2"

if [ ! -d "$SOURCE" ]; then
    echo "Ошибка: '$SOURCE' не является директорией"
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

DATE=$(date +%Y-%m-%d)
ARCHIVE="$BACKUP_DIR/backup-$DATE.tar.gz"

tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"

if [ $? -eq 0 ]; then
    echo "Резервная копия успешно создана: $ARCHIVE"
else
    echo "Ошибка создания резервной копии"
    exit 1
fi

find "$BACKUP_DIR" -type f -name "backup-*.tar.gz" -mtime +7 -exec rm {} \;
