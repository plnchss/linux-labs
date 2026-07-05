#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Использование: $0 <путь_к_директории> <расширение> <число топ-N>"
    exit 1
fi

DIR="$1"
EXT="$2"
TOP_N="$3"

if [ ! -d "$DIR" ]; then
    echo "Ошибка: '$DIR' не является директорией"
    exit 1
fi

declare -A freq

while IFS= read -r -d '' file; do
    while read -r word; do
        word=$(echo "$word" | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]')
        [ -z "$word" ] && continue
        freq["$word"]=$((freq["$word"] + 1))
    done < <(grep -ohE "\w+" "$file")
done < <(find "$DIR" -type f -name "*.$EXT" -print0)

for word in "${!freq[@]}"; do
    echo "${freq[$word]} $word"
done | sort -nr | head -n "$TOP_N" | awk '{print $2": "$1}'
