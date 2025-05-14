# History configuration
HISTFILE="/.local/share/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

# History options
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY           # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS        # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS       # Do not display a line previously found
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording entry
setopt HIST_VERIFY             # Don't execute immediately upon history expansion

# Create history directory if it doesn't exist
[[ ! -d "$(dirname )" ]] && mkdir -p "$(dirname )"

# History search with up/down arrows
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# History search with Ctrl+R
if (( $+commands[fzf] )); then
    function fzf-history() {
        local selected=$(fc -l 1 | fzf --tac --query "" --height 40% --reverse)
        if [[ -n  ]]; then
            local num=$(echo  | awk '{print }')
            zle vi-fetch-history -n 
        fi
        zle redisplay
    }
    zle -N fzf-history
    bindkey '^R' fzf-history
else
    bindkey '^R' history-incremental-search-backward
fi

# History aliases
alias history='fc -l 1'         # Show all history
alias h='history'               # Short alias for history
alias hg='history | grep'       # Search history with grep
alias hc='history -c'           # Clear history
alias hs='history | grep'       # Search history

# Function to show history stats
function print_color() {
    echo -e "\033[m\033[0m"
}

function history-stats() {
    print_color " History Statistics" "36"
    print_color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "34"
    
    # Total commands
    local total=$(fc -l 1 | wc -l)
    print_color "Total commands: " "32"
    
    # Most used commands
    print_color "\nMost used commands:" "33"
    fc -l 1 | awk '{print }' | sort | uniq -c | sort -nr | head -n 10 | while read -r count cmd; do
        print_color "  : " "32"
    done
    
    # Commands by hour
    print_color "\nCommands by hour:" "33"
    fc -l 1 | awk '{print }' | cut -d':' -f1 | sort | uniq -c | sort -nr | while read -r count hour; do
        print_color "  :00 -  commands" "32"
    done
}

# Alias for history stats
alias hst='history-stats'# History configuration
HISTFILE="$HOME/.local/share/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

# History options
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY           # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS        # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS       # Do not display a line previously found
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording entry
setopt HIST_VERIFY             # Don't execute immediately upon history expansion

# Create history directory if it doesn't exist
[[ ! -d "$(dirname $HISTFILE)" ]] && mkdir -p "$(dirname $HISTFILE)"

# History search with up/down arrows
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# History search with Ctrl+R
bindkey '^R' history-incremental-search-backward

# History aliases
alias history='fc -l 1'         # Show all history
alias h='history'               # Short alias for history
alias hg='history | grep'       # Search history with grep
alias hc='history -c'           # Clear history
alias hs='history | grep'       # Search history

# Function to search history with fzf if available
if (( $+commands[fzf] )); then
    function fzf-history() {
        local selected=$(fc -l 1 | fzf --tac --query "$1" --height 40% --reverse)
        if [[ -n $selected ]]; then
            local num=$(echo $selected | awk '{print $1}')
            zle vi-fetch-history -n $num
        fi
        zle redisplay
    }
    zle -N fzf-history
    bindkey '^R' fzf-history
fi

# Function to show history stats
function history-stats() {
    print_color "📊 History Statistics" "$CYAN"
    print_color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$BLUE"
    
    # Total commands
    local total=$(fc -l 1 | wc -l)
    print_color "Total commands: $total" "$GREEN"
    
    # Most used commands
    print_color "\nMost used commands:" "$YELLOW"
    fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -nr | head -n 10 | while read -r count cmd; do
        print_color "  $count: $cmd" "$GREEN"
    done
    
    # Commands by hour
    print_color "\nCommands by hour:" "$YELLOW"
    fc -l 1 | awk '{print $1}' | cut -d':' -f1 | sort | uniq -c | sort -nr | while read -r count hour; do
        print_color "  $hour:00 - $count commands" "$GREEN"
    done
}

# Alias for history stats
alias hs='history-stats' 
