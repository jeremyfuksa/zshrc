# Starship Configuration
# --------------------

# Initialize Starship
eval "$(starship init zsh)"

# Create Starship config directory
mkdir -p ~/.config

# Configure Starship
cat > ~/.config/starship.toml << 'EOF'
# Get started with a custom config
format = """
$os\
$directory\
$git_branch\
$git_status\
$cmd_duration\
$line_break\
$character"""

# Disable modules we don't need for speed
[aws]
disabled = true

[gcloud]
disabled = true

[kubernetes]
disabled = true

# OS indicator
[os]
style = "dimmed blue"
format = "[$symbol]($style) "
disabled = false

# Optimize directory display
[directory]
truncation_length = 3
truncate_to_repo = true
style = "bold blue"
format = "[$path]($style) "
read_only = " 🔒"
read_only_style = "red"

# Optimize git display
[git_branch]
format = "[$symbol$branch]($style) "
symbol = " "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold yellow"
conflicted = "="
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
untracked = "?"
modified = "!"
staged = "+"
renamed = "»"
deleted = "✘"

# Show command duration if it takes more than 1 second
[cmd_duration]
min_time = 1000
format = "[$duration]($style) "
style = "bold yellow"

# Custom prompt character
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vicmd_symbol = "[❮](bold green)"

# Disable right prompt for speed
right_format = ""

# Custom colors
[palette]
blue = "#89B4FA"
purple = "#B4BEFE"
yellow = "#F9E2AF"
green = "#A6E3A1"
red = "#F38BA8"
EOF 
