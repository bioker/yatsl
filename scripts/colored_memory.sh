#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

memory_percentage() {
    available=`free | head -n2 | tail -1 | awk '{print $2}'`
    used=`free | head -n2 | tail -1 | awk '{print $3}'`
    echo "$used $available" | awk '{printf "%3.2f", $1/$2*100}'
}

main() {
    local memory_p=`memory_percentage`
    local memory_c=`color_by_percentage $memory_p`
    echo "${memory_c}${memory_p}${reset_color}"
}

main
