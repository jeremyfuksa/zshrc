# 🚀 Enhanced ZSHRC Modular Setup

A robust, maintainable, and cross-platform zsh configuration system that works across Ubuntu, Debian, and Raspberry Pi OS.

## 🌟 Features

- **Modular Structure**: Easy to maintain and extend
- **Cross-Platform**: Works on Ubuntu, Debian, and Raspberry Pi OS
- **Plugin Management**: Robust Antigen-based plugin system with error logging
- **Version Control**: Built-in backup and restore functionality
- **Platform Detection**: Automatic platform-specific configurations
- **Enhanced Functions**: Useful utilities for system management
- **Improved Keybindings**: Better terminal navigation and editing

## 📁 Directory Structure

```
~/.zshrc                        # Main loader
~/.config/zsh/
├── 00-colors.zsh              # Color constants
├── 05-platform.zsh            # Platform-specific configurations
├── 10-env.zsh                 # Environment setup (NVM, Starship, etc.)
├── 20-antigen.zsh             # Antigen plugin management
├── 30-aliases.zsh             # Common aliases
├── 40-functions.zsh           # Utility functions
├── 50-backup.zsh              # Backup and restore functions
├── 90-functions.zsh           # System management functions
└── 99-keybindings.zsh         # Enhanced keybindings
```

## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/zshrc.git ~/.config/zsh
   ```

2. Run the bootstrap script:
   ```bash
   bash ~/.config/zsh/install.sh
   ```

3. Restart your shell:
   ```bash
   exec zsh
   ```

## 🔧 Requirements

The bootstrap script will install these dependencies:
- curl
- git
- zsh
- lsb-release
- lm-sensors
- bash-completion

## 📦 Optional Dependencies

- NVM (Node Version Manager)
- Starship Prompt
- Antigen (Plugin Manager)

## 🔄 Usage

- `reload` - Reload zsh configuration
- `backup-zsh` - Backup your zsh configuration
- `restore-zsh` - Restore from backup
- `update-all` - Update system packages
- `install` - Quick package installation
- `docker-ls` - List Docker containers
- `ngensite` - Enable Nginx site
- `ngdissite` - Disable Nginx site

## 🛠️ Customization

1. Edit files in `~/.config/zsh/` to customize your setup
2. Add your own functions to `40-functions.zsh`
3. Modify aliases in `30-aliases.zsh`
4. Add platform-specific settings in `05-platform.zsh`

## 📝 License

MIT License - feel free to use and modify for your needs.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 
