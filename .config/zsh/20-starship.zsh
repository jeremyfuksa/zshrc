# Starship Configuration
# --------------------

# Set Starship config location
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Initialize Starship
eval "$(starship init zsh)"

# Add Starship to PATH if not already present
if [[ ! ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
