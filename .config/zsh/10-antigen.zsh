# Antigen Configuration
# -------------------

# Load Antigen
source "$HOME/.antigen/init.zsh"

# Enable Antigen caching for faster startup
ANTIGEN_CACHE=true
ANTIGEN_CACHE_ENABLED=true
ANTIGEN_CACHE_FILE="$HOME/.antigen/.cache"

# Load essential plugins first (fastest loading)
antigen bundle zsh-users/zsh-autocomplete@main  # Fast autocompletion
antigen bundle zsh-users/zsh-syntax-highlighting  # Syntax highlighting
antigen bundle zsh-users/zsh-autosuggestions  # Fish-like suggestions

# Load useful plugins
antigen bundle zsh-users/zsh-completions  # Additional completions
antigen bundle zsh-users/zsh-history-substring-search  # Better history search
antigen bundle MichaelAquilina/zsh-you-should-use  # Suggests aliases
antigen bundle unixorn/git-extra-commands  # Extra git commands
antigen bundle djui/alias-tips  # Alias suggestions
antigen bundle supercrabtree/k  # Better directory listings
antigen bundle zpm-zsh/colorize  # Syntax highlighting for commands
antigen bundle zpm-zsh/ls  # Better ls command
antigen bundle zpm-zsh/undollar  # Remove $ from command line
antigen bundle zpm-zsh/autoenv  # Auto environment loading
antigen bundle zpm-zsh/ssh  # Better SSH handling

# Load theme
antigen theme romkatv/powerlevel10k

# Apply changes
antigen apply 
