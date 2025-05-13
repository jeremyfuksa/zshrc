#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_color() {
    echo -e "${2}${1}${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to update Starship
update_starship() {
    print_color "Updating Starship prompt..." "$BLUE"
    if command_exists starship; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew upgrade starship
        else
            sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --force
        fi
        print_color "✓ Starship updated successfully" "$GREEN"
    else
        print_color "! Starship not found, installing..." "$YELLOW"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install starship
        else
            sh -c "$(curl -fsSL https://starship.rs/install.sh)"
        fi
        print_color "✓ Starship installed" "$GREEN"
    fi
}

# Function to update Antigen
update_antigen() {
    print_color "Updating Antigen..." "$BLUE"
    if [ -f "$HOME/.antigen/antigen.zsh" ]; then
        curl -L git.io/antigen > "$HOME/.antigen/antigen.zsh"
        print_color "✓ Antigen updated successfully" "$GREEN"
    else
        print_color "! Antigen not found, installing..." "$YELLOW"
        mkdir -p "$HOME/.antigen"
        curl -L git.io/antigen > "$HOME/.antigen/antigen.zsh"
        print_color "✓ Antigen installed" "$GREEN"
    fi
}

# Function to update Zsh configuration
update_zsh_config() {
    print_color "Updating Zsh configuration..." "$BLUE"
    
    # Backup current configuration
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"
        print_color "✓ Current .zshrc backed up" "$GREEN"
    fi
    
    # Update configuration files
    if [ -d "$HOME/.config/zsh" ]; then
        # Backup current config directory
        mv "$HOME/.config/zsh" "$HOME/.config/zsh.bak.$(date +%Y%m%d%H%M%S)"
        print_color "✓ Current Zsh config directory backed up" "$GREEN"
        
        # Create new config directory
        mkdir -p "$HOME/.config/zsh"
        print_color "✓ New Zsh config directory created" "$GREEN"
    fi
    
    # Copy new configuration files
    cp -r .config/zsh/* "$HOME/.config/zsh/"
    print_color "✓ New configuration files copied" "$GREEN"
    
    # Update .zshrc
    cp .config/zsh/.zshrc "$HOME/.zshrc"
    print_color "✓ .zshrc updated" "$GREEN"
}

# Function to update system packages
update_system_packages() {
    print_color "Updating system packages..." "$BLUE"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew update && brew upgrade
        print_color "✓ System packages updated" "$GREEN"
    else
        if command_exists apt; then
            sudo apt update && sudo apt upgrade -y
            print_color "✓ System packages updated" "$GREEN"
        elif command_exists dnf; then
            sudo dnf update -y
            print_color "✓ System packages updated" "$GREEN"
        elif command_exists pacman; then
            sudo pacman -Syu --noconfirm
            print_color "✓ System packages updated" "$GREEN"
        else
            print_color "! Package manager not found" "$RED"
        fi
    fi
}

# Main update process
print_color "Starting Zsh configuration update..." "$BLUE"

# Update system packages
update_system_packages

# Update Starship
update_starship

# Update Antigen
update_antigen

# Update Zsh configuration
update_zsh_config

print_color "\nUpdate completed successfully!" "$GREEN"
print_color "Please restart your terminal or run 'exec zsh' to apply changes." "$YELLOW" 
