#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

online_status_color() {
    if $(ping -w 3 -c 1 google.com >/dev/null 2>&1); then
        echo "#[bg=green]"
    else
        echo "#[bg=red]"
    fi
}

main() {
    local online_c=`online_status_color`
    echo "${online_c}WWW${reset_color}"
}

main
