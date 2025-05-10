# Welcome Message
# -------------

# Function to get system uptime in a human-readable format
get_uptime() {
    local uptime_seconds
    uptime_seconds=$(cat /proc/uptime 2>/dev/null | cut -d' ' -f1)
    if [[ -n "$uptime_seconds" ]]; then
        local days=$((uptime_seconds/86400))
        local hours=$((uptime_seconds%86400/3600))
        local minutes=$((uptime_seconds%3600/60))
        if [[ $days -gt 0 ]]; then
            echo "${days}d ${hours}h ${minutes}m"
        elif [[ $hours -gt 0 ]]; then
            echo "${hours}h ${minutes}m"
        else
            echo "${minutes}m"
        fi
    else
        echo "N/A"
    fi
}

# Function to get memory usage
get_memory() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        vm_stat | awk '/Pages free:/ {free=$3} /Pages active:/ {active=$3} /Pages inactive:/ {inactive=$3} /Pages speculative:/ {spec=$3} END {printf "%.1f%%", (active+inactive+spec)/(active+inactive+spec+free)*100}'
    else
        free | awk '/Mem:/ {printf "%.1f%%", $3/$2*100}'
    fi
}

# Function to get CPU temperature (if available)
get_temp() {
    if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
        echo "$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))°C"
    elif command -v osx-cpu-temp >/dev/null 2>&1; then
        osx-cpu-temp
    else
        echo "N/A"
    fi
}

# Print welcome message
print_welcome() {
    local hostname=$(hostname)
    local kernel=$(uname -r)
    local shell_version=$(zsh --version | cut -d' ' -f2)
    local uptime=$(get_uptime)
    local memory=$(get_memory)
    local temp=$(get_temp)
    local date=$(date "+%a %d %b %Y %H:%M:%S")

    # Print header
    echo "\n${fg[blue]}╭──────────────────────────────────────────────────────────╮${reset_color}"
    echo "${fg[blue]}│${reset_color}  ${fg[cyan]}Welcome to ${fg[green]}$hostname${reset_color}"
    echo "${fg[blue]}│${reset_color}  ${fg[yellow]}$date${reset_color}"
    echo "${fg[blue]}├──────────────────────────────────────────────────────────┤${reset_color}"
    
    # Print system info
    echo "${fg[blue]}│${reset_color}  ${fg[cyan]}OS:${reset_color}      ${fg[white]}$(uname -s) $(uname -r)${reset_color}"
    echo "${fg[blue]}│${reset_color}  ${fg[cyan]}Shell:${reset_color}   ${fg[white]}zsh $shell_version${reset_color}"
    echo "${fg[blue]}│${reset_color}  ${fg[cyan]}Uptime:${reset_color}  ${fg[white]}$uptime${reset_color}"
    echo "${fg[blue]}│${reset_color}  ${fg[cyan]}Memory:${reset_color}  ${fg[white]}$memory${reset_color}"
    if [[ "$temp" != "N/A" ]]; then
        echo "${fg[blue]}│${reset_color}  ${fg[cyan]}CPU Temp:${reset_color} ${fg[white]}$temp${reset_color}"
    fi
    
    # Print footer
    echo "${fg[blue]}╰──────────────────────────────────────────────────────────╯${reset_color}\n"
}

# Only show welcome message in interactive shells
if [[ $- == *i* ]]; then
    print_welcome
fi 
