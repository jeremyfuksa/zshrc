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

# Function to check if a backup exists
check_backup() {
    if [ ! -f "$1" ]; then
        print_color "No backup found at $1" "$RED"
        return 1
    fi
    return 0
}

# Restore .zshrc
if check_backup ~/.zshrc.bak; then
    print_color "Restoring .zshrc from backup..." "$BLUE"
    mv ~/.zshrc.bak ~/.zshrc
    print_color "✓ .zshrc restored" "$GREEN"
else
    print_color "Removing .zshrc..." "$BLUE"
    rm -f ~/.zshrc
    print_color "✓ .zshrc removed" "$GREEN"
fi

# Restore ZSH configuration directory
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

# Final message
print_color "\nRestore complete! 🎉" "$GREEN"
print_color "Please restart your terminal to apply changes." "$YELLOW"
print_color "\nThe following items have been restored/removed:" "$BLUE"
print_color "  - .zshrc (restored from backup or removed)" "$GREEN"
print_color "  - ZSH configuration directory" "$GREEN"
print_color "  - Starship configuration" "$GREEN"
print_color "  - Antigen" "$GREEN"
print_color "  - Logs directory" "$GREEN" 
