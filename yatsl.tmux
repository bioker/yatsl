#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

interpolation=(
    "\#{colored_cpu}"
    "\#{colored_memory}"
    "\#{colored_battery}"
    "\#{colored_online}"
)
commands=(
    "#($CURRENT_DIR/scripts/colored_cpu.sh)"
    "#($CURRENT_DIR/scripts/colored_memory.sh)"
    "#($CURRENT_DIR/scripts/colored_battery.sh)"
    "#($CURRENT_DIR/scripts/colored_online.sh)"
)

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

do_interpolation() {
    local all_interpolated="$1"
    for ((i=0; i<${#commands[@]}; i++)); do
    	all_interpolated=${all_interpolated/${interpolation[$i]}/${commands[$i]}}
    done
    echo "$all_interpolated"
}

set_tmux_option() {
    local option="$1"
    local value="$2"
    tmux set-option -gq "$option" "$value"
}

update_tmux_option() {
    local option="$1"
    local option_value="$(get_tmux_option "$option")"
    local new_option_value="$(do_interpolation "$option_value")"
    set_tmux_option "$option" "$new_option_value"
}

main() {
    update_tmux_option "status-right"
}

main
