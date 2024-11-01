# Developer Setup Script for Ubuntu

This script automates the installation of essential development tools on a newly installed Ubuntu machine. It includes the latest versions of software commonly used by developers, such as Docker, Java, IntelliJ IDEA, Visual Studio Code, and more. Additionally, it sets up SSH keys for GitHub authentication and configures Git for commit signing.

## Features

- Installs essential development tools, including:
  - Docker
  - Java (OpenJDK)
  - Maven
  - Node.js and npm
  - IntelliJ IDEA Community Edition
  - Visual Studio Code
  - VLC Media Player
  - Discord
  - Google Chrome
  - Multipass
- Sets up SSH keys for GitHub authentication
- Configures Git for commit signing with SSH keys

## Prerequisites

- This script is intended for Ubuntu systems. Ensure you have a freshly installed Ubuntu environment.
- You need to have sudo privileges to install software.

## Usage

1. **Clone this repository** or download the script to your local machine.

    ```bash
    git clone https://github.com/Awambeng/dev-setup-script.git
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

4. **Follow the prompts**: The script will ask you for your GitHub email and username to generate SSH keys and configure Git.

5. **Add the SSH key to your GitHub account**: After running the script, copy the generated public SSH key from the terminal and add it to your GitHub account under **Settings > SSH and GPG keys**.

## Customization

Feel free to modify the script to include any additional tools or configurations you may need for your specific development environment.

## Contributing

Contributions are welcome! If you would like to improve this script or add new features, please fork the repository, make your changes, and then create a pull request. You can also open an issue to discuss potential changes before implementing them.

## License

This project is licensed under the MIT License.

## Acknowledgments

- Special thanks to the developers and maintainers of the tools included in this script.
