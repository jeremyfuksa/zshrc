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
        local current_version=$(starship --version | head -n1 | cut -d' ' -f2)
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
