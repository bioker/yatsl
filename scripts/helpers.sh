fcomp() {
    awk -v n1=$1 -v n2=$2 'BEGIN {if (n1<n2) exit 0; exit 1}'
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

reset_color="#[default]"
