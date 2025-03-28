# linux_setup
A git repo to install a lot of things when starting a fresh new Debian-based Linux distribution on a computer

# 🖥️ Linux Setup Script

## 📝 Description

A simple script to automate the setup of your Linux system.  
It installs necessary packages, configures useful aliases, sets up the OpenAI API key, and adds the `gpt` command alias.

## ✨ Features

- 📦 Package installation from a list (`linux_libs.txt`)
- 🔄 Alias configuration (`ll`, `la`, `l`, `bat`, `cop`, etc.)
- 🔑 Adds OpenAI API key to `~/.bashrc`
- ⚡ Adds custom `gpt` script alias
- 🔧 Adds `commands` alias for viewing `commands.txt` using `bat`

## 🖥️ Compatibility

- Works on Linux systems
- Requires `sudo` privileges
- Tested on Linux Mint 21.4

## 🚀 Quick Usage

1. Clone the repository:
   ```bash
    git clone https://github.com/olivvius/linux_setup.git
    cd linux-setup
    chmod +x setup.sh
    ./setup.sh
    ```

The script will:

Install your prefered packages from linux_libs.txt and python libs from python_libs.txt

Configure aliases in your ~/.bashrc

Prompt for your OpenAI API key and store it in ~/.bashrc

Add the gpt alias for executing the gpt.sh script

Add the commands alias to view commands.txt with bat

Restart your terminal or run:

```bash
source ~/.bashrc
   ```
This will load the new aliases and environment variables.

## 🛠️ Technologies Used

Bash scripting

OpenAI API integration

Packages management with apt and pip

System configuration

## 📦 Dependencies

sudo privileges required for package installation

apt package manager

batcat for displaying files with bat

## 🔒 Permissions

The script requires sudo privileges to install packages and configure system settings.

## 🚀 Contribution

Fork the project

Create a feature branch

Add your code (don’t forget to follow PEP8 for formatting)

Commit your changes

Push your branch

Submit a Pull Request

## 📄 License

Apache 2.0 License

## 🔜 Possible Future Improvements

Scripts to get all your installed packages and python libs in your former machine to populate linux_libx.txt and python_libs.txt

Automatic system backup before configuration

Support for different Linux distributions

Enhanced error handling for package installation
