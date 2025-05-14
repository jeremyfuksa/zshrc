# Environment Variables
# -------------------

# Set default editor
if [[ -z "$EDITOR" ]]; then
    export EDITOR='nano'
    export VISUAL='nano'
fi

# Set language
if [[ -z "$LANG" ]]; then
    export LANG='en_US.UTF-8'
    export LC_ALL='en_US.UTF-8'
fi

# Set less options
if [[ -z "$LESS" ]]; then
    export LESS='-R --use-color -Dd+r$Du+b'
    export LESSHISTFILE='-'
fi

# Set grep options
if [[ -z "$GREP_OPTIONS" ]]; then
    export GREP_OPTIONS='--color=auto'
    export GREP_COLOR='1;32'
fi

# Set pager
if [[ -z "$PAGER" ]]; then
    export PAGER='less'
fi
