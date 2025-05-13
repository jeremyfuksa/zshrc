# Platform Detection and Configuration
# ----------------------------------

# Detect OS and set basic PATH
case "$(uname)" in
    "Linux")
        export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
        ;;
    "Darwin")
        export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
        ;;
esac

# Print platform information
echo "🌍 Running on $(uname)"
