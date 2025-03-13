#!/bin/bash

dev_tools_list={
    code
    pycharm-ce
    vim
    neovim
    sublime-text
    emacs
    qt-creator
    miniforge
    iterm2
    git
    htop
    tree
}

conda_package_list={
    ros2-humble-desktop
    ros2-humble-desktop-full
    ros2-humble-ros-base
    ros2-humble-ros-core
}

ros_package_list={
    gazebo-ros
    vinca
    turtlesim
    turtlebot3
    dynamixel-sdk
}

#check the cpu architecture of the Mac for path file location
if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin"
else
    BREW_PATH="/usr/local/bin"
fi  

#Function to install CLI tools
install_cli_tools() {

}

# Function to install cask apllications
install_cask() {
    
}

# Function to install Conda pakcages
install_conda_package() {

}

# Function to install ROS packages
install_ros_package() {

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
