#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting minimal installation...${NC}"

# Backup existing .zshrc
if [ -f ~/.zshrc ]; then
    echo -e "${YELLOW}Backing up existing .zshrc...${NC}"
    cp ~/.zshrc ~/.zshrc.bak
    echo -e "${GREEN}Backup created at ~/.zshrc.bak${NC}"
fi

# Create necessary directories
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p ~/.config/zsh/scripts
mkdir -p ~/.config/starship

# Copy configuration files
echo -e "${BLUE}Copying configuration files...${NC}"
cp -r .config/zsh/* ~/.config/zsh/
cp .zshrc ~/.zshrc

# Make scripts executable
echo -e "${BLUE}Making scripts executable...${NC}"
chmod +x ~/.config/zsh/scripts/*

echo -e "${GREEN}Installation complete! 🎉${NC}"
echo -e "${YELLOW}Please restart your terminal or run 'source ~/.zshrc' to apply changes.${NC}" 
