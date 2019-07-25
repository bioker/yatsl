#!/usr/bin/env bash

fcomp() {
	awk -v n1=$1 -v n2=$2 'BEGIN {if (n1<n2) exit 0; exit 1}'
}

cpu_percentage() {
    load=`ps -aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}'`
    cpus=$(nproc)
    echo "$load $cpus" | awk '{printf "%3.1f", $1/$2}'
}

battery_percentage() {
    cat /sys/class/power_supply/BAT0/capacity
}

memory_percentage() {
    available=`free | head -n2 | tail -1 | awk '{print $2}'`
    used=`free | head -n2 | tail -1 | awk '{print $3}'`
    echo "$used $available" | awk '{printf "%3.2f", $1/$2*100}'
}

online_status_color() {
    if $(ping -w 3 -c 1 google.com >/dev/null 2>&1); then
        echo "#[bg=green]"
    else
        echo "#[bg=red]"
    fi
}

color_by_percentage() {
    local percentage=$1
    if fcomp 80 $percentage; then
        echo "#[bg=red]"
    elif fcomp 30 $percentage && fcomp $percentage 80; then 
        echo "#[bg=yellow]"
    else
        echo "#[bg=green]"
    fi
}

color_by_percentage_backward() {
    local percentage=$1
    if fcomp 80 $percentage; then
        echo "#[bg=green]"
    elif fcomp 30 $percentage && fcomp $percentage 80; then 
        echo "#[bg=yellow]"
    else
        echo "#[bg=red]"
    fi
}

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
    local string=$1

    local cpu="\#{colored_cpu}"
    local memory="\#{colored_memory}"
    local battery="\#{colored_battery}"
    local online="\#{colored_online}"
    local reset_color="#[default]"

    local cpu_p=`cpu_percentage`
    local memory_p=`memory_percentage`
    local battery_p=`battery_percentage`

    local cpu_c=`color_by_percentage $cpu_p`
    local memory_c=`color_by_percentage $memory_p`
    local battery_c=`color_by_percentage_backward $battery_p`
    local online_c=`online_status_color`

    local cpu_="${cpu_c}${cpu_p}${reset_color}"
    local memory_="${memory_c}${memory_p}${reset_color}"
    local battery_="${battery_c}${battery_p}${reset_color}"
    local online_="${online_c}WWW${reset_color}"

    local interpolated="${string/$cpu/$cpu_}"
    interpolated="${interpolated/$memory/$memory_}"
    interpolated="${interpolated/$battery/$battery_}"
    interpolated="${interpolated/$online/$online_}"
    echo "$interpolated"
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
