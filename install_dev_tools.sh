#!/bin/bash

# Function to check if a tool is installed
function is_installed() {
    command -v "$1" &> /dev/null
    return $?
}

# Function to install a package if it's not already installed
function install_if_not_installed() {
    if ! is_installed "$1"; then
        echo "Installing $1..."
        sudo apt-get install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Function to prompt for input
function prompt_for_input() {
    local prompt_message="$1"
    local variable_name="$2"
    read -p "$prompt_message: " "$variable_name"
}

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install essential build tools
install_if_not_installed build-essential

# Install Git
install_if_not_installed git

# Install Docker
if ! is_installed docker; then
    echo "Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker "$USER"  # Add user to the docker group
else
    echo "Docker is already installed."
fi

# Install Java (OpenJDK)
if ! is_installed java; then
    echo "Which version of Java would you like to install? (e.g., 17, 21)"
    read -r java_version
    echo "Installing OpenJDK $java_version..."
    sudo apt install -y "openjdk-$java_version-jdk"
else
    echo "Java is already installed."
fi

# Install Maven
install_if_not_installed maven

# Install Curl
install_if_not_installed curl

# Install Node.js and npm
if ! is_installed node; then
    echo "Installing Node.js and npm..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js and npm are already installed."
fi

# Install IntelliJ IDEA Community Edition
if ! is_installed idea; then
    echo "Installing IntelliJ IDEA Community Edition..."
    sudo snap install intellij-idea-community --classic --edge
else
    echo "IntelliJ IDEA Community Edition is already installed."
fi

# Install Visual Studio Code
if ! is_installed code; then
    echo "Installing Visual Studio Code..."
    sudo snap install code --classic
else
    echo "Visual Studio Code is already installed."
fi

# Install VLC
install_if_not_installed vlc

# Install Discord
if ! is_installed discord; then
    echo "Installing Discord..."
    sudo snap install discord
else
    echo "Discord is already installed."
fi

# Install Google Chrome
if ! is_installed google-chrome; then
    echo "Installing Google Chrome..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb  # Clean up
else
    echo "Google Chrome is already installed."
fi

# Install Multipass
if ! is_installed multipass; then
    echo "Installing Multipass..."
    sudo snap install multipass
else
    echo "Multipass is already installed."
fi

# Install SSH (if not already installed)
install_if_not_installed openssh-client
install_if_not_installed openssh-server

# Set up GitHub SSH keys
echo "Setting up GitHub SSH keys..."

# Prompt for user email
prompt_for_input "Enter your GitHub email" git_email

# Prompt for user name
prompt_for_input "Enter your GitHub username" git_username

if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
fi
chmod 700 "$HOME/.ssh"

# Generate SSH key
ssh-keygen -t rsa -b 4096 -C "$git_email" -f "$HOME/.ssh/id_rsa" -N ""

# Start SSH agent
eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/id_rsa"

# Display the public key for GitHub setup
echo "Your public SSH key (add this to your GitHub account):"
cat "$HOME/.ssh/id_rsa.pub"

# Configure Git for commit signing
git config --global user.name "$git_username"  # Use the provided username
git config --global user.email "$git_email"  # Use the provided email
git config --global commit.gpgSign true  # Enable commit signing
git config --global gpg.program "ssh"     # Use SSH for signing

# Clean up
echo "Cleaning up..."
sudo apt autoremove -y

echo "Installation complete! Please add the above SSH key to your GitHub account."
