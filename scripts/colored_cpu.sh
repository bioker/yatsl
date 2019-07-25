#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

cpu_percentage() {
    load=`ps -aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}'`
    cpus=$(nproc)
    echo "$load $cpus" | awk '{printf "%3.1f", $1/$2}'
}

main() {
    local cpu_p=`cpu_percentage`
    local cpu_c=`color_by_percentage $cpu_p`
    echo "${cpu_c}${cpu_p}${reset_color}"
}

main
