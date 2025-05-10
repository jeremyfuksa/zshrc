# Enhanced Utility Functions
# ------------------------

# System Information and Maintenance
sysinfo() {
    echo "💻 System Information"
    echo "-------------------"
    echo "OS: $(uname -s) $(uname -r)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2}')"
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')"
    
    # Add Docker info if available
    if command -v docker >/dev/null 2>&1; then
        echo "\n🐳 Docker Status"
        echo "--------------"
        docker info --format '{{.ServerVersion}}' 2>/dev/null | xargs echo "Version:"
        echo "Containers: $(docker ps -q | wc -l) running"
    fi
    
    # Add Nginx info if available
    if command -v nginx >/dev/null 2>&1; then
        echo "\n🌐 Nginx Status"
        echo "-------------"
        nginx -v 2>&1 | cut -d'/' -f2
        echo "Sites enabled: $(ls /etc/nginx/sites-enabled/ 2>/dev/null | wc -l)"
    fi
}

# Enhanced system update and maintenance
update-all() {
    echo "🔄 System Update and Maintenance"
    echo "----------------------------"
    
    # Ask for confirmation
    read -q "?Do you want to proceed with system updates? (y/N) " || return 1
    echo
    
    case "$OS_NAME" in
        "Ubuntu"|"Debian GNU/Linux"|"Raspberry Pi OS")
            echo "📦 Updating package lists..."
            sudo apt update
            
            echo "⬆️  Available updates:"
            apt list --upgradable
            
            read -q "?Do you want to install these updates? (y/N) " || return 1
            echo
            
            echo "⬆️  Upgrading packages..."
            sudo apt upgrade
            
            echo "🧹 Cleaning up..."
            sudo apt autoremove
            sudo apt autoclean
            
            # Check for Docker updates
            if command -v docker >/dev/null 2>&1; then
                echo "\n🐳 Checking Docker updates..."
                read -q "?Do you want to clean Docker system? (y/N) " || return 1
                echo
                docker system prune -f --volumes
            fi
            ;;
        "macOS")
            echo "📦 Updating Homebrew..."
            brew update
            
            echo "⬆️  Available updates:"
            brew outdated
            
            read -q "?Do you want to install these updates? (y/N) " || return 1
            echo
            
            echo "⬆️  Upgrading packages..."
            brew upgrade
            
            echo "🧹 Cleaning up..."
            brew cleanup
            ;;
    esac
    
    echo "\n✅ System maintenance complete"
}

# Enhanced package management
install() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: install pkg1 [pkg2 ...]"
        return 1
    fi
    
    case "$OS_NAME" in
        "Ubuntu"|"Debian GNU/Linux"|"Raspberry Pi OS")
            echo "📦 Installing packages..."
            sudo apt install "$@"
            ;;
        "macOS")
            echo "🍺 Installing packages..."
            brew install "$@"
            ;;
    esac
}

# Enhanced Nginx management
nginx-manage() {
    local action="$1"
    local site="$2"
    local nginx_dir="${NGINX_DIR:-/etc/nginx}"
    
    case "$action" in
        "enable")
            if [[ -z "$site" ]]; then
                echo "❌ Usage: nginx-manage enable <site>"
                return 1
            fi
            if [[ ! -f "$nginx_dir/sites-available/$site" ]]; then
                echo "❌ Site configuration not found: $site"
                return 1
            fi
            sudo ln -s "$nginx_dir/sites-available/$site" "$nginx_dir/sites-enabled/$site" && \
                echo "✅ Enabled: $site"
            ;;
        "disable")
            if [[ -z "$site" ]]; then
                echo "❌ Usage: nginx-manage disable <site>"
                return 1
            fi
            if [[ ! -L "$nginx_dir/sites-enabled/$site" ]]; then
                echo "❌ Site not enabled: $site"
                return 1
            fi
            sudo rm "$nginx_dir/sites-enabled/$site" && \
                echo "✅ Disabled: $site"
            ;;
        "list")
            echo "📋 Available sites:"
            ls -l "$nginx_dir/sites-available/"
            echo "\n📋 Enabled sites:"
            ls -l "$nginx_dir/sites-enabled/"
            ;;
        "restart")
            read -q "?Do you want to restart Nginx? (y/N) " || return 1
            echo
            sudo systemctl restart nginx
            echo "🔄 Nginx restarted"
            ;;
        *)
            echo "Usage: nginx-manage <enable|disable|list|restart> [site]"
            return 1
            ;;
    esac
}

# Enhanced Docker management
docker-manage() {
    local action="$1"
    local container="$2"
    
    case "$action" in
        "list")
            docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
            ;;
        "clean")
            echo "🧹 Cleaning Docker system..."
            echo "This will remove:"
            echo "- All stopped containers"
            echo "- All unused networks"
            echo "- All dangling images"
            echo "- All build cache"
            read -q "?Do you want to proceed? (y/N) " || return 1
            echo
            docker system prune -f
            ;;
        "stop")
            if [[ -n "$container" ]]; then
                docker stop "$container"
            else
                echo "Stopping all containers..."
                read -q "?Do you want to stop all containers? (y/N) " || return 1
                echo
                docker ps -q | xargs -r docker stop
            fi
            ;;
        "start")
            if [[ -n "$container" ]]; then
                docker start "$container"
            else
                echo "Starting all containers..."
                read -q "?Do you want to start all containers? (y/N) " || return 1
                echo
                docker ps -aq | xargs -r docker start
            fi
            ;;
        "restart")
            if [[ -n "$container" ]]; then
                docker restart "$container"
            else
                echo "Restarting all containers..."
                read -q "?Do you want to restart all containers? (y/N) " || return 1
                echo
                docker ps -q | xargs -r docker restart
            fi
            ;;
        "logs")
            if [[ -z "$container" ]]; then
                echo "❌ Usage: docker-manage logs <container>"
                return 1
            fi
            docker logs -f "$container"
            ;;
        *)
            echo "Usage: docker-manage <list|clean|stop|start|restart|logs> [container]"
            return 1
            ;;
    esac
}

# Enhanced process management
psg() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: psg <pattern>"
        return 1
    fi
    ps aux | grep -i "$1" | grep -v grep
}

# Kill process by name with graceful shutdown
killp() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: killp <process_name>"
        return 1
    fi
    
    local pid=$(ps aux | grep -i "$1" | grep -v grep | awk '{print $2}')
    if [[ -z "$pid" ]]; then
        echo "❌ Process not found"
        return 1
    fi
    
    echo "Found process $pid"
    read -q "?Do you want to kill this process? (y/N) " || return 1
    echo
    
    # Try graceful shutdown first
    echo "Attempting graceful shutdown..."
    kill -15 "$pid"
    
    # Wait for process to terminate
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        if [[ $i -eq 5 ]]; then
            echo "Process not responding to SIGTERM, forcing termination..."
            kill -9 "$pid"
            break
        fi
        sleep 1
        ((i++))
    done
    
    echo "✅ Process terminated"
}

# Directory navigation
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Enhanced file operations
extract() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: extract <file>"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "❌ File not found: $1"
        return 1
    fi
    
    case "$1" in
        *.tar.gz|*.tgz) tar xvzf "$1" ;;
        *.tar.bz2|*.tbz2) tar xvjf "$1" ;;
        *.tar.xz) tar xvJf "$1" ;;
        *.tar) tar xvf "$1" ;;
        *.zip) unzip "$1" ;;
        *.rar) unrar x "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "❌ Unsupported file format" ;;
    esac
}

# Git shortcuts
gits() {
    git status -s
}

gitl() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

# Network utilities
myip() {
    curl -s https://api.ipify.org
}

# Enhanced port scanning
portscan() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: portscan <host> [start_port] [end_port]"
        return 1
    fi
    
    local host="$1"
    local start_port="${2:-1}"
    local end_port="${3:-1024}"
    
    echo "🔍 Scanning $host from port $start_port to $end_port"
    echo "This might take a while..."
    
    # Use timeout to prevent hanging
    for port in $(seq "$start_port" "$end_port"); do
        (timeout 1 bash -c "echo >/dev/tcp/$host/$port") 2>/dev/null && echo "✅ Port $port is open"
    done
}

# System maintenance
cleanup() {
    echo "🧹 Cleaning up system..."
    read -q "?Do you want to proceed? (y/N) " || return 1
    echo
    
    case "$OS_NAME" in
        "Ubuntu"|"Debian GNU/Linux"|"Raspberry Pi OS")
            sudo apt-get clean
            sudo apt-get autoremove
            sudo apt-get autoclean
            ;;
        "macOS")
            brew cleanup
            ;;
    esac
    echo "✅ Cleanup complete"
}

# Enhanced reload function
reload() {
    echo -ne "\n${CYAN}🔁 Reloading shell...${NC}"
    auto-backup
    run_with_spinner "🔁 Sourcing .zshrc..." source ~/.zshrc
    echo -e "\r${GREEN}✅ Reload complete       ${NC}"
}

# Add aliases for all functions
alias si='sysinfo'
alias kp='killp'
alias ex='extract'
alias gs='gits'
alias gl='gitl'
alias dip='docker inspect --format "{{.NetworkSettings.IPAddress}}"'
alias ports='portscan'
alias clean='cleanup'
alias ua='update-all'
alias i='install'
alias ng='nginx-manage'
alias dk='docker-manage'
alias h='help-zsh'

# Analytics wrapper function
analytics_wrapper() {
    local cmd="$1"
    shift
    "$cmd" "$@"
    local exit_code=$?
    zsh-analytics log "$cmd" "$exit_code"
    return $exit_code
}

# Wrap custom commands with analytics
for cmd in sysinfo docker-manage nginx-manage zsh-help backup-zsh update-all; do
    eval "$cmd() { analytics_wrapper $cmd \"\$@\"; }"
done 
