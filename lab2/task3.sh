#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Использование: $0 <путь_к_папке>"
    exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
    echo "Ошибка: '$DIR' не является директорией"
    exit 1
fi

while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    extension="${filename##*.}"

    if [ "$filename" = "$extension" ]; then
        folder="no_extension"
    else
        folder="$extension"
    fi

    mkdir -p "$DIR/$folder"
    mv -- "$file" "$DIR/$folder/"

done < <(find "$DIR" -maxdepth 1 -type f -print0)
