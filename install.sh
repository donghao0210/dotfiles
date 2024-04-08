#!/bin/bash

# Function to log not found packages
log_not_found_packages() {
    echo "The following packages were not found:"
    for pkg in "${not_found_packages[@]}"; do
        echo " - $pkg"
    done 
}

# Downloading Configuration Files
curl -sLfo ~/.p10k.zsh https://raw.githubusercontent.com/donghao0210/dotfiles/main/p10k/p10k.zsh
curl -sLfo ~/.zshrc https://raw.githubusercontent.com/donghao0210/dotfiles/main/zshrc
curl -sLfo ~/.vimrc https://raw.githubusercontent.com/donghao0210/dotfiles/main/vimrc
curl -sLfo ~/.config/neofetch/config.conf https://raw.githubusercontent.com/donghao0210/dotfiles/main/neofetch/neofetch --create-dirs

# Common packages list
common_packages=(
    docker
    docker-compose
    zsh
    grc
    neofetch
    nano
    neovim
    exa
    ripgrep
    bat
    zoxide
    bpython
    mtr
    # Add or remove common packages as needed
)

# Specific packages for Arch Linux
arch_packages=(
    python-argcomplete
    pyenv
    # Add or remove Arch specific packages as needed
)

# Specific packages for Debain-based distributions
debain_packages=(
    # Add or remove Debain specific packages as needed
)
# Initialize array for not found packages
not_found_packages=()

# Function to install packages using a specific package manager
install_packages() {
    local pkg_manager=$1
    local install_cmd=$2
    local update_cmd=$3
    shift 3
    local packages=("$@")

    # Update repositories
    eval "$update_cmd"

    # Try to install each package individually
    for pkg in "${packages[@]}"; do
        if ! eval "$install_cmd $pkg"; then
            not_found_packages+=("$pkg")
        fi
    done
}

# Detect package manager and install packages
if command -v apt >/dev/null 2>&1; then
    # Common packages for Debian-based distributions
    install_packages "apt" "sudo apt install -y" "sudo apt update" "${common_packages[@]}" "${debain_packages[@]}"
elif command -v paru >/dev/null 2>&1; then
    # Common packages for Arch Linux
    install_packages "paru" "paru -S --noconfirm --needed" "paru -Syyyuu" "${common_packages[@]}" "${arch_packages[@]}"
elif command -v pacman >/dev/null 2>&1; then
    # Common packages for Arch Linux
    install_packages "pacman" "sudo pacman -S --noconfirm --needed" "sudo pacman -Syyuu" "${common_packages[@]}" "${arch_packages[@]}"
elif command -v dnf >/dev/null 2>&1; then
    # Common packages for Fedora and Red Hat-based distributions
    install_packages "dnf" "sudo dnf -y install" "sudo dnf -y update" "${common_packages[@]}"
elif command -v zypper >/dev/null 2>&1; then
    # Common packages for openSUSE
    install_packages "zypper" "sudo zypper -y install" "sudo zypper -y update" "${common_packages[@]}"
elif command -v yum >/dev/null 2>&1; then
    # Common packages for CentOS and Red Hat-based distributions
    install_packages "yum" "sudo yum -y install" "sudo yum -y update" "${common_packages[@]}"
else
    echo "No compatible package manager found."
    exit 1
fi

# Log not found packages
if [ ${#not_found_packages[@]} -ne 0 ]; then
    log_not_found_packages
fi