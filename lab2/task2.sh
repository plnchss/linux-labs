#!/bin/bash

DIR="${1:-.}"

if [ ! -d "$DIR" ]; then
    echo "Ошибка: '$DIR' не является директорией"
    exit 1
fi

get_size_kb() {
    local path="$1"
    local total=0
    local seen_inodes=" " 

    while read -r inode blocks; do
          if [[ ! " $seen_inodes " =~ " $inode " ]]; then
        total=$((total + blocks))
         seen_inodes="$seen_inodes $inode"
       fi
    done < <(find "$path" -xdev -print0 2>/dev/null | xargs -0 stat -c '%i %b' 2>/dev/null)

    echo $((total / 2))
}
human_readable() {
    local kb=$1

    if [ "$kb" -ge $((1024 * 1024)) ]; then
        local tenths=$(( (kb * 10 + 512*1024) / 1024 / 1024 ))
        echo "$((tenths / 10)).$((tenths % 10))G"
    elif [ "$kb" -ge 1024 ]; then
        local tenths=$(( (kb * 10 + 512) / 1024 ))
        echo "$((tenths / 10)).$((tenths % 10))M"
    elif [ "$kb" -ge 1 ]; then
        echo "${kb}K"
    else
        echo "0K"
    fi
}

while IFS= read -r -d '' subdir; do
    size_kb=$(get_size_kb "$subdir")
    printf "%s\t%s\n" "$(human_readable "$size_kb")" "$subdir"
done < <(find "$DIR" -maxdepth 1 -type d -print0 2>/dev/null)
