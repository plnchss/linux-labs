#!/bin/bash

echo -n "Введите размер доски: "
read N

COLOR1="\e[44m"
COLOR2="\e[42m"
RESET="\e[0m"

start_with_color=1

for ((i=0; i<N; i++)); do
    if [ $start_with_color -eq 1 ]; then
        current_color=$COLOR1
        next_color=$COLOR2
    else
        current_color=$COLOR2
        next_color=$COLOR1
    fi

    for ((j=0; j<N; j++)); do
        echo -ne "${current_color}  ${RESET}"
        temp=$current_color
        current_color=$next_color
        next_color=$temp
    done
    echo
    if [ $start_with_color -eq 1 ]; then
        start_with_color=0
    else
        start_with_color=1
    fi
done
