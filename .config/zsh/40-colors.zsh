# Color Configuration
# -----------------

# Enable color support
autoload -Uz colors
colors

# Set LS_COLORS for better directory listings
if [[ -f ~/.dircolors ]]; then
    eval $(dircolors ~/.dircolors)
else
    # Professional color scheme for ls
    export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
fi

# Syntax highlighting colors
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=cyan,bold,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[path]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=yellow
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[assign]=fg=blue,bold

# FZF color scheme
export FZF_DEFAULT_OPTS="
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --height 40% --layout=reverse --border --margin=1,4"

# Less colors for man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Grep colors
export GREP_COLORS="mt=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36"

# Git colors
git config --global color.ui true
git config --global color.diff.old "red bold"
git config --global color.diff.new "green bold"
git config --global color.status.added "green bold"
git config --global color.status.changed "yellow bold"
git config --global color.status.untracked "red bold" 
