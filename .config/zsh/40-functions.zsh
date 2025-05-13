# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid > /dev/null; do
        for i in $(seq 0 3); do
            printf "\r${BLUE}%c${NC} " "${spinstr:$i:1}"
            sleep $delay
        done
    done
    printf "\r"
}

# System maintenance
update() {
    local clean=$1
    echo "${BLUE}🔄 System Update${NC}"
    echo "${BLUE}----------------${NC}"
    
    case "$(uname)" in
        "Linux")
            echo "${YELLOW}📦 Updating package lists...${NC}"
            (sudo apt update -y) & spinner $!
            
            echo "${YELLOW}⬆️  Upgrading packages...${NC}"
            (sudo apt upgrade -y) & spinner $!
            
            if [[ "$clean" == "clean" ]]; then
                echo "${YELLOW}🧹 Cleaning up...${NC}"
                (sudo apt autoremove -y && sudo apt autoclean) & spinner $!
            fi
            ;;
        "Darwin")
            echo "${YELLOW}📦 Updating Homebrew...${NC}"
            (brew update) & spinner $!
            
            echo "${YELLOW}⬆️  Upgrading packages...${NC}"
            (brew upgrade) & spinner $!
            
            if [[ "$clean" == "clean" ]]; then
                echo "${YELLOW}🧹 Cleaning up...${NC}"
                (brew cleanup) & spinner $!
            fi
            ;;
    esac
    
    echo "\n${GREEN}✅ Update complete${NC}"
}

# Package management
install() {
    if [[ $# -eq 0 ]]; then
        echo "${RED}Usage: install pkg1 [pkg2 ...]${NC}"
        return 1
    fi
    
    case "$(uname)" in
        "Linux")
            echo "${BLUE}📦 Installing packages: $@${NC}"
            (sudo apt install -y "$@") & spinner $!
            ;;
        "Darwin")
            echo "${BLUE}🍺 Installing packages: $@${NC}"
            (brew install "$@") & spinner $!
            ;;
    esac
    echo "${GREEN}✅ Installation complete${NC}"
}

# File operations
extract() {
    if [[ -f "$1" ]]; then
        echo "${BLUE}📦 Extracting $1...${NC}"
        case "$1" in
            *.tar.gz|*.tgz) tar xvzf "$1" ;;
            *.tar.bz2|*.tbz2) tar xvjf "$1" ;;
            *.tar.xz) tar xvJf "$1" ;;
            *.tar) tar xvf "$1" ;;
            *.zip) unzip "$1" ;;
            *.rar) unrar x "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "${RED}❌ Unsupported file format${NC}" ;;
        esac
        echo "${GREEN}✅ Extraction complete${NC}"
    else
        echo "${RED}❌ File not found: $1${NC}"
    fi
}

# Reload shell configuration
reload() {
    echo "${BLUE}🔁 Reloading shell...${NC}"
    source ~/.zshrc
    echo "${GREEN}✅ Reload complete${NC}"
}
