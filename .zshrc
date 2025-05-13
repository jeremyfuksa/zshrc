#!/bin/zsh

# ZSH Configuration Loader
# ----------------------

# Enable error handling
set -e

# Create log directory if it doesn't exist
ZSH_LOG_DIR="$HOME/.local/share/zsh/logs"
mkdir -p "$ZSH_LOG_DIR"
ZSH_LOG_FILE="$ZSH_LOG_DIR/zsh.log"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo 'unknown')] $1" >> "$ZSH_LOG_FILE"
}

# Source a file with error handling
source_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        log "Loading: $file"
        source "$file" 2>> "$ZSH_LOG_FILE" || log "Error loading: $file"
    else
        log "File not found: $file"
    fi
}

# Load all zsh configuration files
for file in ~/.config/zsh/*.zsh; do
    source_file "$file"
done

# Clean up old log files (keep last 7 days)
find "$ZSH_LOG_DIR" -name "*.log" -mtime +7 -delete 2>/dev/null || true

# Basic PATH setup
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Enable completion
autoload -Uz compinit
compinit

# Enable color support
autoload -Uz colors
colors

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# Enable directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Enable extended globbing
setopt EXTENDED_GLOB

# Enable interactive comments
setopt INTERACTIVE_COMMENTS

# Load Antigen
source /usr/local/share/antigen/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
antigen theme robbyrussell

# Tell Antigen that you're done
antigen apply

# Initialize Starship
eval "$(starship init zsh)"

# Load platform-specific settings if they exist
if [[ -f ~/.config/zsh/platform/$(uname).zsh ]]; then
    source_file ~/.config/zsh/platform/$(uname).zsh
fi

# Load local overrides if they exist
if [[ -f ~/.config/zsh/local.zsh ]]; then
    source_file ~/.config/zsh/local.zsh
fi

# Print welcome message
echo "✨ ZSH configuration loaded successfully!" 
