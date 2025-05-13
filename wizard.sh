#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print with color
print_color() {
    echo -e "${2}${1}${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_color "Please do not run as root" "$RED"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to remove package
remove_package() {
    local package=$1
    if command_exists "$package"; then
        print_color "Removing $package..." "$BLUE"
        case "$(uname)" in
            "Linux")
                if command_exists apt; then
                    sudo apt remove -y "$package" 2>/dev/null
                    sudo apt purge -y "$package" 2>/dev/null
                elif command_exists yum; then
                    sudo yum remove -y "$package" 2>/dev/null
                elif command_exists pacman; then
                    sudo pacman -R --noconfirm "$package" 2>/dev/null
                fi
                ;;
            "Darwin")
                if command_exists brew; then
                    brew uninstall --force "$package" 2>/dev/null
                fi
                ;;
        esac
        print_color "✓ $package removed" "$GREEN"
    fi
}

# Function to check required commands
check_requirements() {
    print_color "Checking required commands..." "$BLUE"
    local missing=0
    
    if ! command_exists "zsh"; then
        print_color "❌ zsh is not installed" "$RED"
        missing=1
    fi
    
    if ! command_exists "git"; then
        print_color "❌ git is not installed" "$RED"
        missing=1
    fi
    
    if ! command_exists "curl"; then
        print_color "❌ curl is not installed" "$RED"
        missing=1
    fi
    
    if [ $missing -eq 1 ]; then
        print_color "\nPlease install the missing requirements before proceeding." "$RED"
        return 1
    fi
    
    print_color "✓ All requirements met" "$GREEN"
    return 0
}

# Function to install
install() {
    print_color "\n🚀 Starting installation..." "$BLUE"
    
    if ! check_requirements; then
        return 1
    fi
    
    # Create necessary directories
    print_color "Creating directories..." "$BLUE"
    mkdir -p ~/.config/zsh
    mkdir -p ~/.config/starship
    mkdir -p ~/.local/share/zsh/logs
    
    # Backup existing configuration
    if [ -f ~/.zshrc ]; then
        print_color "Backing up existing .zshrc..." "$YELLOW"
        cp ~/.zshrc ~/.zshrc.bak
        print_color "Backup created at ~/.zshrc.bak" "$GREEN"
    fi
    
    # Copy configuration files
    print_color "Installing configuration files..." "$BLUE"
    cp -r .config/zsh/* ~/.config/zsh/
    cp .zshrc ~/.zshrc
    
    # Install Starship prompt
    if ! command_exists starship; then
        print_color "Installing Starship prompt..." "$BLUE"
        curl -sS https://starship.rs/install.sh | sh
    fi
    
    # Install Antigen
    if [ ! -d ~/.antigen ]; then
        print_color "Installing Antigen..." "$BLUE"
        git clone https://github.com/zsh-users/antigen.git ~/.antigen
    fi
    
    # Set ZSH as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_color "Setting ZSH as default shell..." "$BLUE"
        chsh -s "$(which zsh)"
    fi
    
    print_color "\nInstallation complete! 🎉" "$GREEN"
    print_color "Please restart your terminal or run 'exec zsh' to apply changes." "$YELLOW"
}

# Function to restore
restore() {
    print_color "\n🔄 Starting restoration..." "$BLUE"
    
    # Restore .zshrc
    if [ -f ~/.zshrc.bak ]; then
        print_color "Restoring .zshrc from backup..." "$BLUE"
        mv ~/.zshrc.bak ~/.zshrc
        print_color "✓ .zshrc restored" "$GREEN"
    else
        print_color "Removing .zshrc..." "$BLUE"
        rm -f ~/.zshrc
        print_color "✓ .zshrc removed" "$GREEN"
    fi
    
    # Remove ZSH configuration directory
    if [ -d ~/.config/zsh ]; then
        print_color "Removing ZSH configuration directory..." "$BLUE"
        rm -rf ~/.config/zsh
        print_color "✓ ZSH configuration removed" "$GREEN"
    fi
    
    # Remove Starship configuration
    if [ -d ~/.config/starship ]; then
        print_color "Removing Starship configuration..." "$BLUE"
        rm -rf ~/.config/starship
        print_color "✓ Starship configuration removed" "$GREEN"
    fi
    
    # Remove Antigen
    if [ -d ~/.antigen ]; then
        print_color "Removing Antigen..." "$BLUE"
        rm -rf ~/.antigen
        print_color "✓ Antigen removed" "$GREEN"
    fi
    
    # Remove logs directory
    if [ -d ~/.local/share/zsh/logs ]; then
        print_color "Removing logs directory..." "$BLUE"
        rm -rf ~/.local/share/zsh/logs
        print_color "✓ Logs removed" "$GREEN"
    fi
    
    print_color "\nRestore complete! 🎉" "$GREEN"
    print_color "Please restart your terminal to apply changes." "$YELLOW"
}

# Function to purge
purge() {
    print_color "\n🧹 Starting purge..." "$BLUE"
    
    # Remove ZSH and its dependencies
    print_color "Removing ZSH and dependencies..." "$BLUE"
    remove_package "zsh"
    remove_package "zsh-common"
    remove_package "zsh-doc"
    
    # Remove curl
    print_color "Removing curl..." "$BLUE"
    remove_package "curl"
    
    # Remove neofetch
    print_color "Removing neofetch..." "$BLUE"
    remove_package "neofetch"
    
    # Remove Starship
    if command_exists starship; then
        print_color "Removing Starship..." "$BLUE"
        case "$(uname)" in
            "Linux")
                sudo rm -f /usr/local/bin/starship
                ;;
            "Darwin")
                brew uninstall --force starship 2>/dev/null
                ;;
        esac
        print_color "✓ Starship removed" "$GREEN"
    fi
    
    # Remove configuration files and directories
    print_color "Removing configuration files and directories..." "$BLUE"
    
    # Remove .zshrc and backup
    rm -f ~/.zshrc
    rm -f ~/.zshrc.bak
    
    # Remove ZSH configuration directory
    rm -rf ~/.config/zsh
    
    # Remove Starship configuration
    rm -rf ~/.config/starship
    
    # Remove Antigen
    rm -rf ~/.antigen
    
    # Remove logs directory
    rm -rf ~/.local/share/zsh/logs
    
    # Remove ZSH cache
    rm -rf ~/.cache/zsh
    rm -rf ~/.zcompcache
    rm -rf ~/.zcompdump*
    
    # Remove ZSH history
    rm -f ~/.zsh_history
    rm -f ~/.zsh_sessions/*
    
    # Remove ZSH completion
    rm -rf ~/.zsh
    
    print_color "\nPurge complete! 🎉" "$GREEN"
    print_color "All ZSH-related packages, configurations, and dependencies have been removed." "$BLUE"
}

# Main menu
show_menu() {
    clear
    print_color "\n🔧 ZSH Configuration Wizard" "$BLUE"
    print_color "=========================" "$BLUE"
    print_color "1. Install" "$GREEN"
    print_color "2. Restore" "$YELLOW"
    print_color "3. Purge" "$RED"
    print_color "4. Exit" "$NC"
    print_color "\nPlease select an option (1-4): " "$BLUE"
}

# Main loop
while true; do
    show_menu
    read -r choice
    
    case $choice in
        1)
            install
            ;;
        2)
            restore
            ;;
        3)
            print_color "\n⚠️  Warning: This will remove all ZSH-related packages and configurations." "$RED"
            read -q "?Are you sure you want to proceed? (y/N) " || continue
            echo
            purge
            ;;
        4)
            print_color "\nGoodbye! 👋" "$BLUE"
            exit 0
            ;;
        *)
            print_color "\nInvalid option. Please try again." "$RED"
            sleep 2
            ;;
    esac
    
    print_color "\nPress Enter to continue..." "$BLUE"
    read -r
done 
