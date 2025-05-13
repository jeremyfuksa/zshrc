#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print with color
print_color() {
    echo -e "${2}${1}${NC}"
}

# Test function
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_status="$3"
    
    print_color "\nRunning test: $test_name" "$BLUE"
    eval "$command"
    local status=$?
    
    if [ $status -eq $expected_status ]; then
        print_color "✅ Test passed: $test_name" "$GREEN"
        return 0
    else
        print_color "❌ Test failed: $test_name (Expected: $expected_status, Got: $status)" "$RED"
        return 1
    fi
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_color "Please do not run as root" "$RED"
    exit 1
fi

# Test required commands
print_color "\nTesting required commands..." "$BLUE"
run_test "ZSH is installed" "zsh --version" 0
run_test "Git is installed" "git --version" 0
run_test "Curl is installed" "curl --version" 0

# Test configuration files
print_color "\nTesting configuration files..." "$BLUE"
run_test "ZSH configuration exists" "[ -f ~/.zshrc ]" 0
run_test "ZSH scripts directory exists" "[ -d ~/.config/zsh/scripts ]" 0
run_test "ZSH platform directory exists" "[ -d ~/.config/zsh/platform ]" 0

# Test scripts
print_color "\nTesting scripts..." "$BLUE"
run_test "ZSH help script is executable" "[ -x ~/.config/zsh/scripts/zsh-help ]" 0
run_test "ZSH help command is available" "command -v zsh-help" 0

# Test Antigen
print_color "\nTesting Antigen..." "$BLUE"
run_test "Antigen is installed" "[ -d ~/.antigen ]" 0

# Test Starship
print_color "\nTesting Starship..." "$BLUE"
run_test "Starship is installed" "command -v starship" 0

# Test custom commands
print_color "\nTesting custom commands..." "$BLUE"
run_test "sysinfo command" "sysinfo" 0
run_test "docker-manage command" "docker-manage --help" 0
run_test "nginx-manage command" "nginx-manage --help" 0

# Final results
print_color "\nTest Summary:" "$BLUE"
print_color "✅ All tests completed!" "$GREEN"
print_color "\nTo start using your new ZSH configuration:" "$YELLOW"
print_color "1. Restart your terminal" "$GREEN"
print_color "2. Run 'zsh-help' to see available commands" "$GREEN"
print_color "3. Customize your configuration in ~/.config/zsh/" "$GREEN" 
