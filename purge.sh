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

# Remove ZSH and its dependencies
print_color "\nRemoving ZSH and dependencies..." "$BLUE"
remove_package "zsh"
remove_package "zsh-common"
remove_package "zsh-doc"

# Remove curl
print_color "\nRemoving curl..." "$BLUE"
remove_package "curl"

# Remove neofetch
print_color "\nRemoving neofetch..." "$BLUE"
remove_package "neofetch"

# Remove Starship
if command_exists starship; then
    print_color "\nRemoving Starship..." "$BLUE"
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
print_color "\nRemoving configuration files and directories..." "$BLUE"

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

# Final message
print_color "\nPurge complete! 🎉" "$GREEN"
print_color "All ZSH-related packages, configurations, and dependencies have been removed." "$BLUE"
print_color "\nThe following items have been removed:" "$BLUE"
print_color "  - ZSH and its dependencies" "$GREEN"
print_color "  - curl" "$GREEN"
print_color "  - neofetch" "$GREEN"
print_color "  - Starship" "$GREEN"
print_color "  - All configuration files and directories" "$GREEN"
print_color "  - All cache and history files" "$GREEN"
print_color "\nYou can now perform a clean installation of the ZSH configuration." "$YELLOW" 
