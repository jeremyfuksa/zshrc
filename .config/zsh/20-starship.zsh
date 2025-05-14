# Starship Configuration
# --------------------

# Check if Starship is installed
if (( $+commands[starship] )); then
    # Set Starship config location
    export STARSHIP_CONFIG="/.config/starship.toml"

    # Initialize Starship
    eval "$(starship init zsh)"

    # Add Starship to PATH if not already present
    if [[ ! "::" == *":/.local/bin:"* ]]; then
        export PATH="/.local/bin:"
    fi
else
    echo "Starship is not installed. Please install it to use this configuration."
fi# Starship Configuration
# --------------------

# Set Starship config location
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Initialize Starship
eval "$(starship init zsh)"

# Add Starship to PATH if not already present
if [[ ! ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
