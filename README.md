# 🚀 zsh-hot-rod

A minimal, modular, and efficient ZSH configuration that combines the power of Antigen and Starship with a clean, professional design.

## ✨ Features

### 🎨 Clean Design
- Professional color scheme
- Elegant prompt with Starship
- Minimal welcome message
- Consistent styling
- Command usage analytics

### ⚡ Performance
- Optimized plugin loading with Antigen
- Fast startup time
- Smart history handling
- Efficient completion system

### 🛠️ Core Tools
- Git integration
- Syntax highlighting
- Smart command suggestions
- Auto environment loading

### 🎯 Productivity
- Intelligent command history
- Smart tab completion
- Command syntax highlighting
- Git command shortcuts

## 🚀 Installation

```bash
# Clone the repository
git clone https://github.com/jeremyfuksa/zshrc.git ~/.config/zsh

# Run the manager script
cd ~/.config/zsh
./zsh-manager.sh
```

## 🎨 Customization

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

## 📦 Dependencies

- ZSH 5.8 or later
- Antigen
- Starship
- Git

## 🎯 Key Bindings

- `Ctrl + R`: History search
- `Ctrl + Space`: Accept autosuggestion
- `Alt + C`: Directory change
- `Alt + F`: File finder
- `Ctrl + T`: File search

## 🛠️ Available Commands

### System
- `update`: Update system packages
- `reload`: Reload ZSH configuration
- `extract`: Extract compressed files

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

## 🔧 Configuration Files

- `.config/zsh/.zshrc`: Main configuration file
- `.config/zsh/20-history.zsh`: History settings
- `.config/zsh/15-env.zsh`: Environment variables
- `.config/zsh/20-starship.zsh`: Starship prompt configuration
- `.config/zsh/40-functions.zsh`: Custom functions
- `.config/zsh/05-platform.zsh`: Platform-specific settings

## 📊 Analytics

The configuration includes basic command usage tracking:

- Command usage frequency
- Command execution times
- Most used commands

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Antigen](https://github.com/zsh-users/antigen)
- [Starship](https://starship.rs)
- [zsh-users](https://github.com/zsh-users)
