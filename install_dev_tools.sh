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
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get install -y "$1"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install "$1"
        fi
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

# Check OS type and run appropriate commands
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Ubuntu specific commands

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

elif [[ "$OSTYPE" == "darwin"* ]]; then 
   # macOS specific commands
   
   # Update Homebrew and upgrade installed packages.
   echo -e "${YELLOW}Step 1: Updating Homebrew...${NC}"
   brew update
   
   echo -e "${YELLOW}Step 2: Upgrading installed packages...${NC}"
   brew upgrade
   
   # Install essential build tools (Xcode Command Line Tools)
   xcode-select --install
   
   # Install Git, Docker, Java, Maven, Node.js, IntelliJ IDEA, etc.
   install_if_not_installed git
   
   if ! is_installed docker; then 
       echo -e "${YELLOW}Installing Docker...${NC}" 
       brew install --cask docker 
   else 
       echo -e "${GREEN}Docker is already installed.${NC}" 
   fi 

   if ! is_installed java; then 
       echo "Which version of Java would you like to install? (e.g., 17, 21)" 
       read -r java_version 
       echo -e "${YELLOW}Installing OpenJDK $java_version...${NC}" 
       brew tap homebrew/cask-versions 
       brew install "openjdk@$java_version" 
   else 
       echo -e "${GREEN}Java is already installed.${NC}" 
   fi 

   install_if_not_installed maven 

   if ! is_installed node; then 
       echo -e "${YELLOW}Installing Node.js and npm...${NC}" 
       brew install node 
   else 
       echo -e "${GREEN}Node.js and npm are already installed.${NC}" 
   fi 

   if ! is_installed idea; then 
       echo -e "${YELLOW}Installing IntelliJ IDEA Community Edition...${NC}" 
       brew install --cask intellij-idea-ce 
   else 
       echo -e "${GREEN}IntelliJ IDEA Community Edition is already installed.${NC}" 
   fi 

   if ! is_installed code; then 
       echo -e "${YELLOW}Installing Visual Studio Code...${NC}" 
       brew install --cask visual-studio-code 
   else 
       echo -e "${GREEN}Visual Studio Code is already installed.${NC}" 
   fi 

else 
   echo "Unsupported OS type: $OSTYPE"
   exit 1 
fi 

# Clean up unused dependencies.
echo -e "${YELLOW}Cleaning up...${NC}"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then 
   sudo apt autoremove -y 
elif [[ "$OSTYPE" == "darwin"* ]]; then 
   brew cleanup 
fi 

echo -e "${GREEN}=============================================================="
echo -e "      All done! Your system is ready for work. 🎉"
echo -e "==============================================================${NC}"
