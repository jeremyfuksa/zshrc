# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Spinner animation
spinner() {
    local pid=
    local delay=0.1
    local spinstr='|/-\'
    while ps -p  > /dev/null; do
        for i in $(seq 0 3); do
            printf "\r%c " ":1"
            sleep 
        done
    done
    printf "\r"
}

# System maintenance
update() {
    local clean=
    echo " System Update"
    echo "----------------"
    
    # Ask for confirmation
    read -q "?Do you want to proceed with system updates? (y/N) " || return 1
    echo
    
    case "$(uname)" in
        "Linux")
            if command -v apt &> /dev/null; then
                echo " Updating package lists..."
                (sudo apt update -y) & spinner $!
                
                echo " Available updates:"
                apt list --upgradable
                
                read -q "?Do you want to install these updates? (y/N) " || return 1
                echo
                
                echo " Upgrading packages..."
                (sudo apt upgrade -y) & spinner $!
                
                if [[ "" == "clean" ]]; then
                    echo " Cleaning up..."
                    (sudo apt autoremove -y && sudo apt autoclean) & spinner $!
                fi
            else
                echo " Unsupported package manager"
            fi
            ;;
        "Darwin")
            if command -v brew &> /dev/null; then
                echo " Updating Homebrew..."
                (brew update) & spinner $!
                
                echo " Available updates:"
                brew outdated
                
                read -q "?Do you want to install these updates? (y/N) " || return 1
                echo
                
                echo " Upgrading packages..."
                (brew upgrade) & spinner $!
                
                if [[ "" == "clean" ]]; then
                    echo " Cleaning up..."
                    (brew cleanup) & spinner $!
                fi
            else
                echo " Homebrew is not installed"
            fi
            ;;
        *)
            echo " Unsupported platform"
            ;;
    esac
    
    echo "\n Update complete"
}

# File operations
extract() {
    if [[ -f "" ]]; then
        echo " Extracting ..."
        case "" in
            *.tar.gz|*.tgz) tar xvzf "" || echo " Extraction failed" ;;
            *.tar.bz2|*.tbz2) tar xvjf "" || echo " Extraction failed" ;;
            *.tar.xz) and sudo apt install -y xz-utils &> /dev/null; then
                tar xvJf "" || echo " Extraction failed"
            else
                echo " xz-utils is not installed"
            fi
            ;;
            *.tar) tar xvf "" || echo " Extraction failed" ;;
            *.zip) unzip "" || echo " Extraction failed" ;;
            *.rar) unrar x "" || echo " Extraction failed" ;;
            *.7z) 7z x "" || echo " Extraction failed" ;;
            *) echo " Unsupported file format" ;;
        esac
        echo " Extraction complete"
    else
        echo " File not found: "
    fi
}

# Reload shell configuration
reload() {
    echo " Reloading shell..."
    source "-/.zshrc"
    echo " Reload complete"
}# Color definitions
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
    
    # Ask for confirmation
    read -q "?Do you want to proceed with system updates? (y/N) " || return 1
    echo
    
    case "$(uname)" in
        "Linux")
            echo "${YELLOW}📦 Updating package lists...${NC}"
            (sudo apt update -y) & spinner $!
            
            echo "${YELLOW}⬆️  Available updates:${NC}"
            apt list --upgradable
            
            read -q "?Do you want to install these updates? (y/N) " || return 1
            echo
            
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
            
            echo "${YELLOW}⬆️  Available updates:${NC}"
            brew outdated
            
            read -q "?Do you want to install these updates? (y/N) " || return 1
            echo
            
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
