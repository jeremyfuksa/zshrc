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
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ZSH_LOG_FILE"
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
find "$ZSH_LOG_DIR" -name "*.log" -mtime +7 -delete

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

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

# Enable prompt expansion
setopt PROMPT_SUBST

# Enable directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Enable extended globbing
setopt EXTENDED_GLOB

# Enable interactive comments
setopt INTERACTIVE_COMMENTS

# Load platform-specific settings if they exist
if [[ -f ~/.config/zsh/platform/$(uname).zsh ]]; then
    source_file ~/.config/zsh/platform/$(uname).zsh
fi

# Load local overrides if they exist
if [[ -f ~/.config/zsh/local.zsh ]]; then
    source_file ~/.config/zsh/local.zsh
fi

# Analytics integration
if [[ -f ~/.config/zsh/scripts/zsh-analytics ]]; then
    # Log shell startup time
    zsh-analytics log_shell_startup "$(($(date +%s%N) - ${START_TIME:-0}))"
    
    # Log directory changes
    function chpwd() {
        zsh-analytics log_directory_usage "$PWD"
    }
    
    # Log alias usage
    function alias() {
        if [[ $# -eq 0 ]]; then
            builtin alias
        else
            zsh-analytics log_alias_usage "$1"
            builtin alias "$@"
        fi
    }
fi

# Print welcome message
echo "✨ ZSH configuration loaded successfully!" 
