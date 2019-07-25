#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

battery_percentage() {
    cat /sys/class/power_supply/BAT0/capacity
}

main() {
    local battery_p=`battery_percentage`
    local battery_c=`color_by_percentage_backward $battery_p`
    echo "${battery_c}${battery_p}${reset_color}"
}

main
