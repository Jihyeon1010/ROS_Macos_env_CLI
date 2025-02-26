#!/bin/bash

cli_list={
    git
    wget
    curl
    vim
    htop
}

cask_list={
    pycharm-ce
    visual-studio-code
    iterm2
}

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew, macOS package manager..."
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Ensure Homebrew is available immediately
    eval "$($BREW_PATH/brew shellenv)"

    # Update and upgrade Homebrew
    echo "Updating Homebrew..."
    brew update
    brew upgrade
    
    echo "Homebrew installation and path setup complete!"
else
    echo "Homebrew is already installed."
fi

#Add Homebrew to PATH in .zshrcc if not already present
ZSHRC="$HOME/.zshrc"
if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$ZSHRC"; then
    echo "Adding Homebrew to PATH in .zshrc"
    echo "eval \"$($BREW_PATH/brew shellenv)\"" >> "$ZSHRC"
    echo "export PATH=\"$BREW_PATH:\$PATH\"" >> "$ZSHRC"
    source "$ZSHRC"
fi