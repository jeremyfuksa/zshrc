# Antigen Configuration
# -------------------

# Load Antigen
source "$HOME/.antigen/init.zsh"

# Enable Antigen caching for faster startup
ANTIGEN_CACHE=true
ANTIGEN_CACHE_ENABLED=true
ANTIGEN_CACHE_FILE="$HOME/.antigen/.cache"

# Essential plugins only
antigen bundle zsh-users/zsh-autosuggestions  # Fish-like suggestions
antigen bundle zsh-users/zsh-syntax-highlighting  # Syntax highlighting
antigen bundle git  # Git integration

# Apply changes
antigen apply 
