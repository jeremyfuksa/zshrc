#!/bin/bash
# ZSH Configuration Manager
# A comprehensive tool for managing ZSH configuration, installation, and maintenance

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

# Function to get latest Starship version
get_latest_starship_version() {
    curl -s https://api.github.com/repos/starship/starship/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Function to check current setup
check_setup() {
    print_color "\n🔍 Checking current setup..." "$BLUE"
    print_color "This may take a moment..." "$CYAN"
    
    # Check ZSH
    if command_exists zsh; then
        print_color "✓ ZSH is installed" "$GREEN"
        print_color "  Version: $(zsh --version)" "$CYAN"
    else
        print_color "❌ ZSH is not installed" "$RED"
    fi
    
    # Check Starship
    if command_exists starship; then
        print_color "✓ Starship is installed" "$GREEN"
        local current_version=$(starship --version | cut -d' ' -f2)
        local latest_version=$(get_latest_starship_version)
        print_color "  Current version: $current_version" "$CYAN"
        print_color "  Latest version: $latest_version" "$CYAN"
        if [ "$current_version" = "$latest_version" ]; then
            print_color "  ✓ Starship is up to date" "$GREEN"
        else
            print_color "  ⚠️  Starship update available" "$YELLOW"
        fi
    else
        print_color "❌ Starship is not installed" "$RED"
    fi
    
    # Check Antigen
    if [ -d ~/.antigen ]; then
        print_color "✓ Antigen is installed" "$GREEN"
        print_color "  Location: ~/.antigen" "$CYAN"
    else
        print_color "❌ Antigen is not installed" "$RED"
    fi
    
    # Check configuration files
    if [ -f ~/.config/zsh/.zshrc ]; then
        print_color "✓ ZSH configuration exists" "$GREEN"
        print_color "  Location: ~/.config/zsh/.zshrc" "$CYAN"
    else
        print_color "❌ ZSH configuration is missing" "$RED"
    fi
    
    if [ -f ~/.config/starship.toml ]; then
        print_color "✓ Starship configuration exists" "$GREEN"
        print_color "  Location: ~/.config/starship.toml" "$CYAN"
    else
        print_color "❌ Starship configuration is missing" "$RED"
    fi
    
    # Check if ZSH is default shell
    if [ "$SHELL" = "$(which zsh)" ]; then
        print_color "✓ ZSH is set as default shell" "$GREEN"
        print_color "  Current shell: $SHELL" "$CYAN"
    else
        print_color "❌ ZSH is not set as default shell" "$RED"
        print_color "  Current shell: $SHELL" "$CYAN"
        print_color "  Expected: $(which zsh)" "$CYAN"
    fi
    
    print_color "\nCheck complete! 🎉" "$GREEN"
}

# Function to install
install() {
    print_color "\n🚀 Starting installation..." "$BLUE"
    
    if ! check_requirements; then
        return 1
    fi
    
    # Get the directory where the script is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    
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
    if [ -d "$SCRIPT_DIR/.config/zsh" ]; then
        cp -r "$SCRIPT_DIR/.config/zsh/"* ~/.config/zsh/
    else
        print_color "❌ Source directory not found: $SCRIPT_DIR/.config/zsh" "$RED"
        return 1
    fi
    
    if [ -f "$SCRIPT_DIR/.zshrc" ]; then
        cp "$SCRIPT_DIR/.zshrc" ~/.zshrc
    else
        print_color "❌ Source file not found: $SCRIPT_DIR/.zshrc" "$RED"
        return 1
    fi
    
    # Copy Starship configuration
    if [ -f "$SCRIPT_DIR/.config/starship.toml" ]; then
        print_color "Installing Starship configuration..." "$BLUE"
        cp "$SCRIPT_DIR/.config/starship.toml" ~/.config/starship.toml
        print_color "✓ Starship configuration installed" "$GREEN"
    else
        print_color "⚠️  Starship configuration not found in source" "$YELLOW"
    fi
    
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

# Function to update
update() {
    print_color "\n🔄 Starting update..." "$BLUE"
    
    # Update Antigen
    if [ -d ~/.antigen ]; then
        print_color "Updating Antigen..." "$BLUE"
        cd ~/.antigen && git pull
        print_color "✓ Antigen updated" "$GREEN"
    fi
    
    # Update Starship
    if command_exists starship; then
        print_color "Updating Starship..." "$BLUE"
        curl -sS https://starship.rs/install.sh | sh
        print_color "✓ Starship updated" "$GREEN"
    fi
    
    # Update configuration files
    print_color "Updating configuration files..." "$BLUE"
    cp -r .config/zsh/* ~/.config/zsh/
    cp .zshrc ~/.zshrc
    
    if [ -f .config/starship.toml ]; then
        cp .config/starship.toml ~/.config/starship.toml
    fi
    
    print_color "\nUpdate complete! 🎉" "$GREEN"
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

# Function to show help
show_help() {
    clear
    print_color "\n📚 ZSH Configuration Manager Help" "$BLUE"
    print_color "=============================" "$BLUE"
    
    print_color "\nThis tool helps you manage your ZSH configuration:" "$CYAN"
    print_color "• Install and update your ZSH setup" "$CYAN"
    print_color "• Check your current configuration" "$CYAN"
    print_color "• Restore or remove your setup" "$CYAN"
    
    print_color "\nAvailable commands:" "$CYAN"
    print_color "1. Check    - Verify current ZSH setup and configuration" "$GREEN"
    print_color "   • Shows installed components" "$CYAN"
    print_color "   • Displays version information" "$CYAN"
    print_color "   • Checks configuration files" "$CYAN"
    
    print_color "\n2. Install  - Install or reinstall ZSH configuration" "$GREEN"
    print_color "   • Sets up ZSH with Antigen" "$CYAN"
    print_color "   • Configures Starship prompt" "$CYAN"
    print_color "   • Creates necessary directories" "$CYAN"
    
    print_color "\n3. Update   - Update existing installation" "$GREEN"
    print_color "   • Updates Antigen and Starship" "$CYAN"
    print_color "   • Refreshes configuration files" "$CYAN"
    
    print_color "\n4. Restore  - Restore previous configuration" "$YELLOW"
    print_color "   • Restores from backup if available" "$CYAN"
    print_color "   • Removes current configuration" "$CYAN"
    
    print_color "\n5. Purge    - Remove all ZSH-related packages and configs" "$RED"
    print_color "   • Removes ZSH and dependencies" "$CYAN"
    print_color "   • Deletes all configuration files" "$CYAN"
    print_color "   • Cleans up cache and logs" "$CYAN"
    
    print_color "\n6. Help     - Show this help message" "$BLUE"
    print_color "7. Exit     - Exit the program" "$NC"
    
    print_color "\nPress Enter to return to main menu..." "$BLUE"
    read -r
}

# Main menu
show_menu() {
    clear
    print_color "\n🔧 ZSH Configuration Manager" "$BLUE"
    print_color "=========================" "$BLUE"
    print_color "\n1. Check   - Verify current setup" "$CYAN"
    print_color "2. Install - Install configuration" "$GREEN"
    print_color "3. Update  - Update installation" "$GREEN"
    print_color "4. Restore - Restore previous config" "$YELLOW"
    print_color "5. Purge   - Remove everything" "$RED"
    print_color "6. Help    - Show help" "$BLUE"
    print_color "7. Exit    - Exit program" "$NC"
    print_color "\nPlease select an option (1-7): " "$BLUE"
}

# Main loop
while true; do
    show_menu
    read -r choice
    
    case $choice in
        1)
            check_setup
            ;;
        2)
            install
            ;;
        3)
            update
            ;;
        4)
            restore
            ;;
        5)
            print_color "\n⚠️  Warning: This will remove all ZSH-related packages and configurations." "$RED"
            read -q "?Are you sure you want to proceed? (y/N) " || continue
            echo
            purge
            ;;
        6)
            show_help
            ;;
        7)
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
