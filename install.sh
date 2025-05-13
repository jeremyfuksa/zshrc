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

# Check for required commands
check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_color "Required command '$1' not found. Please install it first." "$RED"
        exit 1
    fi
}

# Check required commands
print_color "Checking required commands..." "$BLUE"
check_command "zsh"
check_command "git"
check_command "curl"

# Create necessary directories
print_color "Creating directories..." "$BLUE"
mkdir -p ~/.config/zsh/{scripts,platform}
mkdir -p ~/.config/starship

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
if ! command -v starship &> /dev/null; then
    print_color "Installing Starship prompt..." "$BLUE"
    curl -sS https://starship.rs/install.sh | sh
fi

# Install Antigen
if [ ! -d ~/.antigen ]; then
    print_color "Installing Antigen..." "$BLUE"
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
fi

# Make scripts executable
print_color "Setting up scripts..." "$BLUE"
chmod +x ~/.config/zsh/scripts/*

# Create symlinks for scripts
print_color "Creating symlinks..." "$BLUE"
sudo ln -sf ~/.config/zsh/scripts/zsh-help /usr/local/bin/zsh-help

# Set ZSH as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    print_color "Setting ZSH as default shell..." "$BLUE"
    chsh -s "$(which zsh)"
fi

# Final message
print_color "\nInstallation complete! 🎉" "$GREEN"
print_color "Please restart your terminal or run 'exec zsh' to apply changes." "$YELLOW"
print_color "\nAvailable commands:" "$BLUE"
print_color "  - zsh-help: Show available commands and features" "$GREEN"
print_color "  - sysinfo: Display system information" "$GREEN"
print_color "  - docker-manage: Manage Docker containers" "$GREEN"
print_color "  - nginx-manage: Manage Nginx sites" "$GREEN"
print_color "\nFor more information, visit:" "$BLUE"
print_color "https://github.com/yourusername/zsh-hot-rod" "$GREEN" 
