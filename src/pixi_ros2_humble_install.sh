#!/bin/bash

command_line_tools_list={
    htop
    tree
    pixi

}


dev_tools_list={
    code
    pycharm-ce
    vim
    neovim
    sublime-text
    emacs
    qt-ecreator
    git
}

pixi_list={
    ros-humble-desktop
    ros-humble-desktop-full
    ros-humble-ros-base
    ros-humble-ros-core
}

ros_package_list={
    gazebo
    turtlebot3
    dynamixel-sdk
    moveit
    turtlesim
    navigation2
    image-view
    camera-calibration
    camke
    complier
    ninja
    pkg-config
    ament-camke-auto
    navigation2
    nav2-bringup
}

#check the cpu architecture of the Mac for path file location
if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin"
else
    BREW_PATH="/usr/local/bin"
fi  

#Function to install CLI tools
install_cli_tools() {
    if [[ -n "$cli_list" ]]; then
        for cli in "${cli_list[@]}"; do
            if ! command -v "$cli" &>/dev/null; then
                echo "$cli not found. Installing $cli..."
                brew install "$cli"
            else
                echo "$cli is already installed."
            fi
        done
    else
        echo "No CLI tools to install."
    fi
}

# Function to install cask apllications
install_cask() {
    if [[ -n "$cask_list" ]]; then
        for cask in "${cask_list[@]}"; do
            if ! brew list --cask | grep -q "$cask"; then
                echo "$cask not found. Installing $cask..."
                brew install --cask "$cask"
            else
                echo "$cask is already installed."
            fi
        done
    else
        echo "No cask applications to install."
    fi
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
