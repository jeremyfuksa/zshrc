# Platform Detection and Configuration
# ----------------------------------

# Detect OS
case "$(uname)" in
    "Linux")
        # Detect Linux distribution
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            OS_NAME="$NAME"
            OS_VERSION="$VERSION_ID"
        else
            OS_NAME="Unknown Linux"
            OS_VERSION="Unknown"
        fi
        
        # Distribution-specific configurations
        case "$OS_NAME" in
            "Ubuntu"|"Debian GNU/Linux")
                # Ubuntu/Debian specific settings
                alias update='sudo apt update'
                alias upgrade='sudo apt upgrade'
                alias install='sudo apt install'
                alias remove='sudo apt remove'
                alias autoremove='sudo apt autoremove'
                ;;
            "Raspberry Pi OS")
                # Raspberry Pi specific settings
                alias temp='vcgencmd measure_temp'
                alias clock='vcgencmd measure_clock arm'
                alias voltage='vcgencmd measure_volts'
                ;;
        esac
        ;;
    "Darwin")
        # macOS specific settings
        OS_NAME="macOS"
        OS_VERSION="$(sw_vers -productVersion)"
        
        # Homebrew specific aliases
        alias update='brew update'
        alias upgrade='brew upgrade'
        alias install='brew install'
        alias remove='brew uninstall'
        alias cleanup='brew cleanup'
        ;;
esac

# Platform-specific environment variables
case "$OS_NAME" in
    "Ubuntu"|"Debian GNU/Linux"|"Raspberry Pi OS")
        export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
        ;;
    "macOS")
        export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
        ;;
esac

# Platform-specific completion
case "$OS_NAME" in
    "Ubuntu"|"Debian GNU/Linux"|"Raspberry Pi OS")
        if [[ -f /etc/bash_completion ]]; then
            . /etc/bash_completion
        fi
        ;;
    "macOS")
        if [[ -f /usr/local/etc/bash_completion ]]; then
            . /usr/local/etc/bash_completion
        fi
        ;;
esac

# Print platform information
echo "🌍 Running on $OS_NAME $OS_VERSION" 
