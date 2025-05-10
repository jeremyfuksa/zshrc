#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Log function
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root"
fi

# Detect OS
case "$(uname)" in
    "Linux")
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            OS_NAME="$NAME"
            OS_VERSION="$VERSION_ID"
        else
            error "Could not detect Linux distribution"
        fi
        ;;
    "Darwin")
        OS_NAME="macOS"
        OS_VERSION="$(sw_vers -productVersion)"
        ;;
    *)
        error "Unsupported operating system"
        ;;
esac

log "Detected $OS_NAME $OS_VERSION"

# Create necessary directories
log "Creating configuration directories..."
mkdir -p ~/.config/zsh
mkdir -p ~/.config/zsh/scripts
mkdir -p ~/.local/share/zsh/{logs,backups}

# Install dependencies
log "Installing dependencies..."
case "$OS_NAME" in
    "Ubuntu"|"Debian GNU/Linux"|"Raspberry Pi OS")
        sudo apt update
        sudo apt install -y \
            curl \
            git \
            zsh \
            lsb-release \
            lm-sensors \
            bash-completion \
            tar \
            unzip \
            || error "Failed to install dependencies"
        ;;
    "macOS")
        if ! command -v brew >/dev/null 2>&1; then
            log "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install \
            curl \
            git \
            zsh \
            bash-completion \
            || error "Failed to install dependencies"
        ;;
esac

# Install Antigen
log "Installing Antigen..."
if [[ ! -f "$HOME/.antigen/init.zsh" ]]; then
    mkdir -p "$HOME/.antigen"
    curl -sL https://git.io/antigen > "$HOME/.antigen/init.zsh" \
        || error "Failed to install Antigen"
fi

# Install Starship
log "Installing Starship prompt..."
if ! command -v starship >/dev/null 2>&1; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y \
        || error "Failed to install Starship"
fi

# Copy configuration files
log "Copying configuration files..."
cp -r .config/zsh/* ~/.config/zsh/ \
    || error "Failed to copy configuration files"

# Make scripts executable
log "Making scripts executable..."
chmod +x ~/.config/zsh/scripts/* \
    || warn "Failed to make scripts executable"

# Create symlinks for scripts
log "Creating script symlinks..."
for script in ~/.config/zsh/scripts/*; do
    if [[ -x "$script" ]]; then
        script_name=$(basename "$script")
        sudo ln -sf "$script" "/usr/local/bin/$script_name" \
            || warn "Failed to create symlink for $script_name"
    fi
done

# Set up .zshrc
log "Setting up .zshrc..."
if [[ -f ~/.zshrc ]]; then
    mv ~/.zshrc ~/.zshrc.bak
    warn "Backed up existing .zshrc to .zshrc.bak"
fi
ln -s ~/.config/zsh/.zshrc ~/.zshrc \
    || error "Failed to create .zshrc symlink"

# Set default shell to zsh
if [[ "$SHELL" != "$(which zsh)" ]]; then
    log "Setting default shell to zsh..."
    chsh -s "$(which zsh)" \
        || warn "Failed to set default shell to zsh"
fi

# Create initial backup
log "Creating initial backup..."
~/.config/zsh/50-backup.zsh \
    || warn "Failed to create initial backup"

log "✅ Installation complete!"
echo -e "\nPlease restart your terminal or run:"
echo -e "  ${YELLOW}exec zsh${NC}" 
