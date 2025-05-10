# Performance Optimizations
# -----------------------

# Optimize completion system
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Optimize history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# Optimize directory handling
setopt AUTO_CD
setopt CDABLE_VARS
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt NO_CASE_GLOB

# Optimize command execution
setopt NO_BEEP
setopt NO_LIST_BEEP
setopt NO_HUP
setopt NO_CHECK_JOBS

# Optimize word splitting
setopt NO_SH_WORD_SPLIT
setopt NO_BASH_REMATCH

# Optimize path handling
typeset -U path cdpath fpath manpath

# Optimize completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Optimize directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Optimize command correction
setopt NO_CORRECT
setopt NO_CORRECT_ALL

# Optimize job control
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_CHECK_JOBS

# Optimize prompt
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

# Optimize key bindings
bindkey -e
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Optimize directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Optimize common commands
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Optimize git commands
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias gb='git branch'
alias gco='git checkout'

# Optimize system commands
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'

# Optimize directory creation
alias mkdir='mkdir -p'

# Optimize file operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Optimize process management
alias ps='ps aux'
alias psg='ps aux | grep'

# Optimize network commands
alias myip='curl -s https://api.ipify.org'
alias ports='netstat -tulanp'

# Optimize system updates
alias update='sudo apt update && sudo apt upgrade -y'
alias cleanup='sudo apt autoremove -y && sudo apt clean'

# Optimize shell management
alias reload='source ~/.zshrc'
alias zshconfig='vim ~/.zshrc'
alias ohmyzsh='vim ~/.oh-my-zsh'

# Optimize directory navigation with fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Optimize command history with fzf
bindkey '^R' fzf-history-widget

# Optimize directory navigation with z
[ -f /usr/local/etc/profile.d/z.sh ] && source /usr/local/etc/profile.d/z.sh 
