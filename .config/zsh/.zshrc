#!/bin/zsh

# ZSH Configuration Loader
# ----------------------

# Create log directory
ZSH_LOG_DIR="$HOME/.local/share/zsh/logs"
mkdir -p "$ZSH_LOG_DIR" || {
    echo "Error creating log directory: $ZSH_LOG_DIR" >&2
    exit 1
}
ZSH_LOG_FILE="$ZSH_LOG_DIR/zsh.log"
ZSH_ERROR_LOG_FILE="$ZSH_LOG_DIR/zsh_error.log"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ZSH_LOG_FILE"
}

# Error log function
error_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ZSH_ERROR_LOG_FILE"
}

# Source a file with error handling
source_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        log "Loading: $file"
        if ! source "$file" 2>> "$ZSH_ERROR_LOG_FILE"; then
            error_log "Error loading: $file"
            log "Error loading: $file"
        fi
    else
        error_log "File not found: $file"
        log "File not found: $file"
    fi
}

# Load all zsh configuration files
ZSH_CONFIG_DIR="$HOME/.config/zsh"
if [[ -d "$ZSH_CONFIG_DIR" ]]; then
    for file in "$ZSH_CONFIG_DIR"/*.zsh; do
        source_file "$file"
    done
else
    error_log "Configuration directory not found: $ZSH_CONFIG_DIR"
    log "Configuration directory not found: $ZSH_CONFIG_DIR"
fi

# Clean up old log files (keep last 7 days)
find "$ZSH_LOG_DIR" -type f -name "*.log" -mtime +7 -delete 2>/dev/null || true
