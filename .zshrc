#!/bin/zsh

# ZSH Configuration Loader
# ----------------------

# Create log directory
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
find "$ZSH_LOG_DIR" -name "*.log" -mtime +7 -delete 2>/dev/null || true 
