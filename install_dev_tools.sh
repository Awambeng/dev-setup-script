#!/bin/bash

# Function to prompt for input
prompt_for_input() {
    local prompt_message="$1"
    local variable_name="$2"
    read -p "$prompt_message: " "$variable_name"
}

# Update and upgrade the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install essential build tools
echo "Installing build-essential..."
sudo apt install -y build-essential

# Install Git
echo "Installing Git..."
sudo apt install -y git

# Install Docker
echo "Installing Docker..."
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER  # Add user to the docker group

# Install Java (OpenJDK)
echo "Installing Java (OpenJDK)..."
sudo apt install -y openjdk-17-jdk

# Install Maven
echo "Installing Maven..."
sudo apt install -y maven

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install IntelliJ IDEA Community Edition
echo "Installing IntelliJ IDEA Community Edition..."
sudo snap install intellij-idea-community --classic --edge

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
sudo snap install code --classic

# Install VLC
echo "Installing VLC..."
sudo apt install -y vlc

# Install Discord
echo "Installing Discord..."
sudo snap install discord

# Install Google Chrome
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb  # Clean up

# Install Multipass
echo "Installing Multipass..."
sudo snap install multipass

# Install SSH (if not already installed)
echo "Installing SSH..."
sudo apt install -y openssh-client openssh-server

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
