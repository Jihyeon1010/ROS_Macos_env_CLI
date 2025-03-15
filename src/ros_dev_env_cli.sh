#!/bin/bash

# === ROS Development Environment Installer for macOS ===

# =================== Lists ===================

# List of ROS distributions
ros_distro_list=("noetic" "foxy" "galactic" "humble" "jazzy")

# Development tools list (macOS equivalents via brew)
development_tools_list=(
    git cmake wget curl vim neovim
    htop tree tmux zsh 
)

# Pixi/Conda package list
common_packages_list=(
    numpy scipy matplotlib pandas scikit-learn scikit-image opencv
    tensorflow keras pytorch torch torchvision jupyter ipython
    spyder pylint flake8
)

# ROS packages (can be cloned or installed via source)
ros_packages_list=(
    turtlebot3_simulations
    turtlebot3_gazebo
    dynamixel_sdk
)

# Detect Homebrew Path
if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin"
else
    BREW_PATH="/usr/local/bin"
fi

# Add Homebrew path if not in .zshrc
ZSHRC="$HOME/.zshrc"
if ! grep -q 'brew shellenv' "$ZSHRC"; then
    echo "Adding Homebrew path to .zshrc..."
    echo 'eval "$('"$BREW_PATH"'/brew shellenv)"' >> "$ZSHRC"
    echo "export PATH=\"$BREW_PATH:\$PATH\"" >> "$ZSHRC"
    source "$ZSHRC"
fi

# =================== Functions ===================

# Main Menu
menu() {
    clear
    echo
    echo "===================================="
    echo "     ROS Development Installer"
    echo "===================================="
    echo "1) Install ROS Environment"
    echo "2) Install ROS Packages"
    echo "3) Install Pixi or Conda Packages"
    echo "4) Install Development Tools"
    echo "5) About"
    echo "6) Quit"
    echo "------------------------------------"
    echo
    read -p "Choose an option [1-6]: " MENU_OPTION
}

# About Menu
show_about() {
    clear
    echo "===================================="
    echo "  ROS Development Env Installer"
    echo "------------------------------------"
    echo "- Terminal-based installer"
    echo "- Supports Pixi & Conda environments"
    echo "- Installs ROS tools and development stacks"
    echo "- Ideal for ROS on macOS"
    echo "===================================="
    echo
    read -p "Press Enter to return to the main menu..."
}

# Select ROS Distro
ros_distro_selection() {
    echo
    echo "Available ROS distributions:"
    for i in "${!ros_distro_list[@]}"; do
        echo "$((i+1))) ${ros_distro_list[$i]}"
    done
    echo "$(( ${#ros_distro_list[@]}+1 ))) Back"
    read -p "Select ROS version [1-${#ros_distro_list[@]}]: " choice

    if [[ "$choice" -ge 1 && "$choice" -le ${#ros_distro_list[@]} ]]; then
        ROS_VERSION="${ros_distro_list[$((choice-1))]}"
    else
        ROS_VERSION="back"
    fi
}

# Select install method
select_install_method() {
    echo
    echo "Select installation method:"
    echo "1) Pixi"
    echo "2) Conda"
    echo "3) Back"
    echo
    read -p "Your choice [1-3]: " METHOD_CHOICE
    case $METHOD_CHOICE in
        1) INSTALL_METHOD="pixi" ;;
        2) INSTALL_METHOD="conda" ;;
        *) INSTALL_METHOD="back" ;;
    esac
}

# Install Development Tools
install_dev_tools() {
    echo "📦 Installing development tools via Homebrew..."
    for pkg in "${development_tools_list[@]}"; do
        brew install "$pkg" >/dev/null 2>&1 || echo "⚠️  Failed to install: $pkg"
    done
    echo "✅ Development tools installation completed."
    read -p "Press Enter to return to main menu..."
}

# Install Common Pixi/Conda Packages
install_pixi_conda_packages() {
    select_install_method
    if [[ "$INSTALL_METHOD" == "back" ]]; then return; fi

    if [[ "$INSTALL_METHOD" == "pixi" ]]; then
        if ! command -v pixi &> /dev/null; then
            echo "❌ Pixi not installed. Installing..."
            curl -fsSL https://pixi.sh/install.sh | bash
            export PATH="$HOME/.pixi/bin:$PATH"
        fi
        pixi init --name ros-env --python 3.10
        for pkg in "${common_packages_list[@]}"; do
            pixi add "$pkg"
        done
        echo "✅ Pixi packages installed. Run: pixi shell"
    elif [[ "$INSTALL_METHOD" == "conda" ]]; then
        if ! command -v conda &> /dev/null; then
            echo "❌ Conda not found. Download from https://docs.conda.io/"
            return
        fi
        conda create -n ros-env python=3.10 -y
        source "$(conda info --base)/etc/profile.d/conda.sh"
        conda activate ros-env
        conda install -y -c conda-forge "${common_packages_list[@]}"
        echo "✅ Conda packages installed. Run: conda activate ros-env"
    fi
    read -p "Press Enter to return to main menu..."
}

# Install ROS Packages
install_ros_packages() {
    echo "📦 Cloning common ROS packages to ~/ros_packages/"
    mkdir -p ~/ros_packages && cd ~/ros_packages || return
    for pkg in "${ros_packages_list[@]}"; do
        if [[ ! -d "$pkg" ]]; then
            echo "➡ Cloning $pkg..."
            git clone "https://github.com/ROBOTIS-GIT/${pkg}.git"
        else
            echo "✔ $pkg already exists. Skipping..."
        fi
    done
    echo "✅ ROS packages cloned to ~/ros_packages/"
    read -p "Press Enter to return to main menu..."
}

# =================== Main Loop ===================
while true; do
    menu
    case $MENU_OPTION in
        1)
            ros_distro_selection
            if [[ "$ROS_VERSION" != "back" ]]; then
                select_install_method
                echo "🔧 Preparing environment for $ROS_VERSION using $INSTALL_METHOD..."
                # (You can insert ROS setup here if needed)
                echo "✅ Selected ROS Version: $ROS_VERSION, Method: $INSTALL_METHOD"
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            install_dev_tools
            ;;
        3)
            install_pixi_conda_packages
            ;;
        4)
            install_ros_packages
            ;;
        5)
            show_about
            ;;
        6)
            echo "👋 Exiting... Goodbye!"
            break
            ;;
        *)
            echo "❌ Invalid option. Try again."
            sleep 1
            ;;
    esac
done
