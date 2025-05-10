# 🚀 zsh-hot-rod

A blazing fast, beautifully designed, and feature-rich ZSH configuration that combines the power of Antigen and Starship with professional aesthetics and modern functionality.

![zsh-hot-rod](https://i.imgur.com/example.png)

## ✨ Features

### 🎨 Beautiful Design
- Professional color scheme based on Catppuccin
- Elegant prompt with Starship
- Clean and informative welcome message
- Consistent styling across all tools
- Subtle animations and transitions
- Command usage analytics with beautiful visualizations

### ⚡ Performance
- Optimized plugin loading with Antigen caching
- Fast startup time
- Efficient command execution
- Smart history handling
- Optimized completion system
- Command execution time tracking

### 🛠️ Modern Tools
- Fuzzy finding with `fzf`
- Fast file search with `fd`
- Quick code search with `ripgrep`
- Smart directory jumping with `z`
- Enhanced process management with `htop`

### 🔧 Development Features
- Git integration with beautiful status display
- Syntax highlighting for multiple languages
- Smart command suggestions
- Alias tips and suggestions
- Auto environment loading

### 🎯 Productivity
- Intelligent command history
- Directory stack navigation
- Smart tab completion
- Command syntax highlighting
- Git command shortcuts

## 🚀 Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/zsh-hot-rod.git ~/.config/zsh

# Run the installation script
cd ~/.config/zsh
./install.sh
```

## 🎨 Customization

### Colors
The color scheme can be customized in `.config/zsh/40-colors.zsh`:
```zsh
# Professional color scheme for ls
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
```

### Prompt
Customize your prompt in `.config/zsh/20-starship.zsh`:
```toml
format = """
$directory\
$git_branch\
$git_status\
$cmd_duration\
$line_break\
$character"""
```

### Welcome Message
Modify the welcome message in `.config/zsh/50-welcome.zsh`:
```zsh
print_welcome() {
    # Customize system information display
}
```

## 📦 Dependencies

- ZSH 5.8 or later
- Antigen
- Starship
- fzf
- ripgrep
- fd
- htop
- neofetch

## 🎯 Key Bindings

- `Ctrl + R`: Fuzzy history search
- `Ctrl + Space`: Accept autosuggestion
- `Alt + C`: Fuzzy directory change
- `Alt + F`: Fuzzy file finder
- `Ctrl + T`: Fuzzy file search

## 🛠️ Available Commands

### System
- `si`: Show system information
- `ua`: Update system packages
- `clean`: Clean up system
- `zsh-analytics`: View command usage statistics and analytics

### Git
- `g`: Git command
- `ga`: Git add
- `gc`: Git commit
- `gp`: Git push
- `gpl`: Git pull
- `gs`: Git status
- `gd`: Git diff
- `gl`: Git log
- `gb`: Git branch
- `gco`: Git checkout

### Directory Navigation
- `..`: Go up one directory
- `...`: Go up two directories
- `z <dir>`: Jump to frequent directory

### Process Management
- `psg <pattern>`: Search for processes
- `kp <name>`: Kill process by name

## 🔧 Configuration Files

- `.config/zsh/10-antigen.zsh`: Plugin management
- `.config/zsh/20-starship.zsh`: Prompt configuration
- `.config/zsh/30-performance.zsh`: Performance optimizations
- `.config/zsh/40-colors.zsh`: Color schemes
- `.config/zsh/40-functions.zsh`: Custom functions and utilities
- `.config/zsh/50-welcome.zsh`: Welcome message
- `.config/zsh/scripts/zsh-analytics`: Command usage analytics script

## 📊 Analytics

The configuration includes a powerful analytics system that tracks:
- Command usage frequency
- Command execution times
- Most used commands
- Command patterns and trends

To view your command analytics, simply run:
```bash
zsh-analytics
```

This will display a beautiful visualization of your command usage patterns and statistics.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Antigen](https://github.com/zsh-users/antigen)
- [Starship](https://starship.rs)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
- [zsh-users](https://github.com/zsh-users) 
