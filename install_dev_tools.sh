#!/bin/bash

# Define color variables
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Function to check if a tool is installed
function is_installed() {
    command -v "$1" &> /dev/null
    return $?
}

# Function to install a package if it's not already installed
function install_if_not_installed() {
    if ! is_installed "$1"; then
        echo -e "${YELLOW}Installing $1...${NC}"
        sudo apt-get install -y "$1"
        echo -e "${GREEN}$1 installed successfully!${NC}\n"
    else
        echo -e "${GREEN}$1 is already installed.${NC}"
    fi
}

# Function to prompt for input
function prompt_for_input() {
    local prompt_message="$1"
    local variable_name="$2"
    read -p "$prompt_message: " "$variable_name"
}

echo -e "${GREEN}=============================================================="
echo -e "      Welcome! Starting your system setup for work! 🚀"
echo -e "==============================================================${NC}\n"

# Update and upgrade package list
echo -e "${YELLOW}Step 1: Updating the package lists...${NC}"
sudo apt-get update -y
echo -e "${GREEN}Package lists updated successfully!${NC}\n"

echo -e "${YELLOW}Step 2: Upgrading the system...${NC}"
sudo apt-get upgrade -y
echo -e "${GREEN}System upgrade completed!${NC}\n"

# Install essential build tools
install_if_not_installed build-essential

# Install Git
install_if_not_installed git

# Install Docker
if ! is_installed docker; then
    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker "$USER"  # Add user to the docker group
else
    echo -e "${GREEN}Docker is already installed.${NC}"
fi

# Install Java (OpenJDK)
if ! is_installed java; then
    echo "Which version of Java would you like to install? (e.g., 17, 21)"
    read -r java_version
    echo -e "${YELLOW}Installing OpenJDK $java_version...${NC}"
    sudo apt install -y "openjdk-$java_version-jdk"
else
    echo -e "${GREEN}Java is already installed.${NC}"
fi

# Install Maven
install_if_not_installed maven

# Install Node.js and npm
if ! is_installed node; then
    echo -e "${YELLOW}Installing Node.js and npm...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo -e "${GREEN}Node.js and npm are already installed.${NC}"
fi

# Install IntelliJ IDEA Community Edition
if ! is_installed idea; then
    echo -e "${YELLOW}Installing IntelliJ IDEA Community Edition...${NC}"
    sudo snap install intellij-idea-community --classic --edge
else
    echo -e "${GREEN}IntelliJ IDEA Community Edition is already installed.${NC}"
fi

# Install Visual Studio Code
if ! is_installed code; then
    echo -e "${YELLOW}Installing Visual Studio Code...${NC}"
    sudo snap install code --classic
else
    echo -e "${GREEN}Visual Studio Code is already installed.${NC}"
fi

# Install VLC
install_if_not_installed vlc

# Install Discord
if ! is_installed discord; then
    echo -e "${YELLOW}Installing Discord...${NC}"
    sudo snap install discord
else
    echo -e "${GREEN}Discord is already installed.${NC}"
fi

# Install Google Chrome
if ! is_installed google-chrome; then
    echo -e "${YELLOW}Installing Google Chrome...${NC}"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb  # Clean up
else
    echo -e "${GREEN}Google Chrome is already installed.${NC}"
fi

# Install Multipass
if ! is_installed multipass; then
    echo -e "${YELLOW}Installing Multipass...${NC}"
    sudo snap install multipass
else
    echo -e "${GREEN}Multipass is already installed.${NC}"
fi

# Install SSH (client and server)
install_if_not_installed openssh-client
install_if_not_installed openssh-server

# Ask if the user wants to set up GitHub SSH keys
echo -e "${YELLOW}Would you like to set up GitHub SSH keys? (y/n)${NC}"
read -r setup_ssh
if [[ "$setup_ssh" == "y" || "$setup_ssh" == "Y" ]]; then
    echo -e "${YELLOW}Setting up GitHub SSH keys...${NC}"

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
    echo -e "${YELLOW}Your public SSH key (add this to your GitHub account):${NC}"
    cat "$HOME/.ssh/id_rsa.pub"

    # Configure Git for commit signing
    git config --global user.name "$git_username"  # Use the provided username
    git config --global user.email "$git_email"  # Use the provided email
    git config --global commit.gpgSign true  # Enable commit signing
    git config --global gpg.program "ssh"     # Use SSH for signing
else
    echo -e "${GREEN}Skipping SSH setup.${NC}"
fi

# Clean up
echo -e "${YELLOW}Cleaning up...${NC}"
sudo apt autoremove -y

echo -e "${GREEN}=============================================================="
echo -e "      All done! Your system is ready for work. 🎉"
echo -e "==============================================================${NC}"
