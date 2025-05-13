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
        # Get just the version number from the first line
        local current_version=$(starship --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        local latest_version=$(get_latest_starship_version | sed 's/^v//')
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
    if [ -f ~/.zshrc ]; then
        print_color "✓ ZSH configuration exists" "$GREEN"
        print_color "  Location: ~/.zshrc" "$CYAN"
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
    if [ -d "$SCRIPT_DIR/config/zsh" ]; then
        cp -r "$SCRIPT_DIR/config/zsh/"* ~/.config/zsh/
    else
        print_color "❌ Source directory not found: $SCRIPT_DIR/config/zsh" "$RED"
        return 1
    fi
    
    if [ -f "$SCRIPT_DIR/config/zsh/.zshrc" ]; then
        cp "$SCRIPT_DIR/config/zsh/.zshrc" ~/.zshrc
    else
        print_color "❌ Source file not found: $SCRIPT_DIR/config/zsh/.zshrc" "$RED"
        return 1
    fi
    
    # Copy Starship configuration
    if [ -f "$SCRIPT_DIR/config/starship.toml" ]; then
        print_color "Installing Starship configuration..." "$BLUE"
        cp "$SCRIPT_DIR/config/starship.toml" ~/.config/starship.toml
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
    
    # Get the directory where the script is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    
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
    if [ -d "$SCRIPT_DIR/config/zsh" ]; then
        cp -r "$SCRIPT_DIR/config/zsh/"* ~/.config/zsh/
    else
        print_color "❌ Source directory not found: $SCRIPT_DIR/config/zsh" "$RED"
        return 1
    fi
    
    if [ -f "$SCRIPT_DIR/config/zsh/.zshrc" ]; then
        cp "$SCRIPT_DIR/config/zsh/.zshrc" ~/.zshrc
    else
        print_color "❌ Source file not found: $SCRIPT_DIR/config/zsh/.zshrc" "$RED"
        return 1
    fi
    
    if [ -f "$SCRIPT_DIR/config/starship.toml" ]; then
        cp "$SCRIPT_DIR/config/starship.toml" ~/.config/starship.toml
        print_color "✓ Starship configuration updated" "$GREEN"
    else
        print_color "⚠️  Starship configuration not found in source" "$YELLOW"
    fi
    
    print_color "\nUpdate complete! 🎉" "$GREEN"
    print_color "Please restart your terminal or run 'exec zsh' to apply changes." "$YELLOW"
} 
