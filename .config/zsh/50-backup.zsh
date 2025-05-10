# Backup and Restore Functions
# --------------------------

# Backup directory
ZSH_BACKUP_DIR="$HOME/.local/share/zsh/backups"
mkdir -p "$ZSH_BACKUP_DIR"

# Create a backup of zsh configuration
backup-zsh() {
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_file="$ZSH_BACKUP_DIR/zsh_backup_$timestamp.tar.gz"
    
    echo "📦 Creating backup..."
    tar -czf "$backup_file" \
        ~/.zshrc \
        ~/.config/zsh \
        ~/.zsh_history \
        ~/.antigen \
        2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Backup created: $backup_file"
        
        # Clean up old backups (keep last 5)
        ls -t "$ZSH_BACKUP_DIR"/zsh_backup_*.tar.gz | tail -n +6 | xargs -r rm
        
        # Show backup size
        du -h "$backup_file"
    else
        echo "❌ Backup failed"
        return 1
    fi
}

# List available backups
list-zsh-backups() {
    if [[ -d "$ZSH_BACKUP_DIR" ]]; then
        echo "📋 Available backups:"
        ls -lh "$ZSH_BACKUP_DIR"/zsh_backup_*.tar.gz 2>/dev/null || echo "No backups found"
    else
        echo "❌ Backup directory not found"
        return 1
    fi
}

# Restore from backup
restore-zsh() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: restore-zsh <backup_file>"
        list-zsh-backups
        return 1
    fi
    
    local backup_file="$1"
    if [[ ! -f "$backup_file" ]]; then
        echo "❌ Backup file not found: $backup_file"
        return 1
    fi
    
    echo "⚠️  This will overwrite your current zsh configuration"
    read -q "?Are you sure? (y/N) " || return 1
    echo
    
    echo "🔄 Restoring from backup..."
    tar -xzf "$backup_file" -C "$HOME"
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Restore complete"
        echo "🔄 Please restart your shell or run 'reload'"
    else
        echo "❌ Restore failed"
        return 1
    fi
}

# Auto-backup before major changes
auto-backup() {
    if [[ ! -f "$ZSH_BACKUP_DIR/.last_backup" ]] || \
       [[ $(( $(date +%s) - $(stat -f %m "$ZSH_BACKUP_DIR/.last_backup") )) -gt 86400 ]]; then
        backup-zsh
        touch "$ZSH_BACKUP_DIR/.last_backup"
    fi
}

# Add backup aliases
alias zb='backup-zsh'
alias zl='list-zsh-backups'
alias zr='restore-zsh' 
