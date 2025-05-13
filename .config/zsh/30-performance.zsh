# Performance Optimizations
# -----------------------

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Optimize completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

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
