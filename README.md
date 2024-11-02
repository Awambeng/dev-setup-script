# Developer Setup Script for Ubuntu and macOS

This script automates the installation of essential development tools on a newly installed Ubuntu or macOS machine. It includes the latest versions of software commonly used by developers, such as Docker, Java, IntelliJ IDEA, Visual Studio Code, and more. Additionally, it sets up SSH keys for GitHub authentication and configures Git for commit signing, with an option to skip the SSH setup.

## Features

- Installs essential development tools, including:
  - Docker
  - Java (OpenJDK) with version selection
  - Maven
  - Node.js and npm
  - IntelliJ IDEA Community Edition
  - Visual Studio Code
  - VLC Media Player
  - Discord
  - Google Chrome
  - Multipass
- Optionally sets up SSH keys for GitHub authentication
- Configures Git for commit signing with SSH keys
- Automatically detects the operating system (Ubuntu or macOS) and installs appropriate packages

## Prerequisites

- This script is intended for Ubuntu and macOS systems. Ensure you have a freshly installed environment.
- You need to have sudo privileges to install software on Ubuntu.
- On macOS, ensure you have Homebrew installed.

## Usage

1. **Clone this repository** or download the script to your local machine.

    ```bash
    git clone https://github.com/yourusername/dev-setup-script.git
    cd dev-setup-script
    ```

2. **Make the script executable**:

    ```bash
    chmod +x install_dev_tools.sh
    ```

3. **Run the script**:

    ```bash
    ./install_dev_tools.sh
    ```

4. **Follow the prompts**:
    - The script will automatically detect your operating system and ask you for your desired Java version and your GitHub email to generate SSH keys and configure Git.
    - You will also have the option to skip the SSH setup if you do not need GitHub SSH keys.

5. **Add the SSH key to your GitHub account** (if you chose to set up SSH keys):
    - After running the script, copy the generated public SSH key from the terminal and add it to your GitHub account under **Settings > SSH and GPG keys**.

## Customization

Feel free to modify the script to include any additional tools or configurations you may need for your specific development environment.

## Script output example

```bash
Installing maven...
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
maven is already the newest version (3.8.7-1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
maven installed successfully!

Node.js and npm are already installed.
Installing IntelliJ IDEA Community Edition...
snap "intellij-idea-community" is already installed, see 'snap help refresh'
Visual Studio Code is already installed.
Cleaning up...
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
==============================================================
      All done! Your system is ready for work. 🎉
==============================================================
```

## Contributing

Contributions are welcome! If you would like to improve this script or add new features, please fork the repository, make your changes, and then create a pull request. You can also open an issue to discuss potential changes before implementing them.

## License

This project is licensed under the MIT License.

## Acknowledgments

- Special thanks to the developers and maintainers of the tools included in this script.
