# Platform Detection and Configuration
# ----------------------------------

# Detect OS and set basic PATH
case "$(uname)" in
    "Linux")
        PATH_DIRS=("/usr/local/sbin" "/usr/local/bin" "/usr/sbin" "/usr/bin" "/sbin" "/bin")
        ;;
    "Darwin")
        PATH_DIRS=("/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin")
        ;;
    *)
        echo "Unsupported platform: $(uname)" >&2
        return 1
        ;;
esac

# Add directories to PATH if they exist
for dir in "${PATH_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        PATH="$dir:$PATH"
    fi
done
export PATH

# Print platform information
echo "🌍 Running on $(uname -s) $(uname -r) ($(uname -m))"
