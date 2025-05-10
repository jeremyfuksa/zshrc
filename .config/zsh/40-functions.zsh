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
    
    case "$OS_NAME" in
        "Ubuntu"|"Debian GNU/Linux"|"Raspberry Pi OS")
            echo "📦 Updating package lists..."
            sudo apt update -y
            
            echo "⬆️  Upgrading packages..."
            sudo apt upgrade -y
            
            echo "🧹 Cleaning up..."
            sudo apt autoremove -y
            sudo apt autoclean
            
            # Check for Docker updates
            if command -v docker >/dev/null 2>&1; then
                echo "\n🐳 Checking Docker updates..."
                docker system prune -af --volumes
            fi
            ;;
        "macOS")
            echo "📦 Updating Homebrew..."
            brew update
            
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
            sudo apt install -y "$@"
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
    
    case "$action" in
        "enable")
            [[ $site ]] && sudo ln -s "/etc/nginx/sites-available/$site" "/etc/nginx/sites-enabled/$site" && \
                echo "✅ Enabled: $site" || echo "❌ Usage: nginx-manage enable <site>"
            ;;
        "disable")
            [[ $site ]] && sudo rm "/etc/nginx/sites-enabled/$site" && \
                echo "✅ Disabled: $site" || echo "❌ Usage: nginx-manage disable <site>"
            ;;
        "list")
            echo "📋 Available sites:"
            ls -l /etc/nginx/sites-available/
            echo "\n📋 Enabled sites:"
            ls -l /etc/nginx/sites-enabled/
            ;;
        "restart")
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
            docker system prune -af --volumes
            ;;
        "stop")
            [[ $container ]] && docker stop "$container" || docker ps -q | xargs -r docker stop
            ;;
        "start")
            [[ $container ]] && docker start "$container" || docker ps -aq | xargs -r docker start
            ;;
        "restart")
            [[ $container ]] && docker restart "$container" || docker ps -q | xargs -r docker restart
            ;;
        "logs")
            [[ $container ]] && docker logs -f "$container" || echo "❌ Usage: docker-manage logs <container>"
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

# Kill process by name
killp() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: killp <process_name>"
        return 1
    fi
    local pid=$(ps aux | grep -i "$1" | grep -v grep | awk '{print $2}')
    if [[ -n "$pid" ]]; then
        kill -9 "$pid"
        echo "✅ Killed process $pid"
    else
        echo "❌ Process not found"
    fi
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
    if [[ -f "$1" ]]; then
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
    else
        echo "❌ File not found: $1"
    fi
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

portscan() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: portscan <host>"
        return 1
    fi
    for port in {1..65535}; do
        (echo >/dev/tcp/$1/$port) 2>/dev/null && echo "Port $port is open"
    done
}

# System maintenance
cleanup() {
    echo "🧹 Cleaning up system..."
    case "$OS_NAME" in
        "Ubuntu"|"Debian GNU/Linux"|"Raspberry Pi OS")
            sudo apt-get clean
            sudo apt-get autoremove -y
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

# Add help alias
alias h='help-zsh' 
