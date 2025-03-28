# Privileges 
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires sudo privileges. Please enter your password."
  sudo "$0" "$@"
  exit 0
fi

# Package installs

FILE="linux_libs.txt"

if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

echo "Updating package lists..."
sudo apt update

echo "Installing packages..."
while IFS= read -r package || [[ -n "$package" ]]; do
    if [[ ! -z "$package" && ! "$package" =~ ^# ]]; then
        echo "Installing: $package"
        if ! sudo apt install -y "$package"; then
            echo "Error installing: $package" >> install_errors.log
        fi
    fi
done < "$FILE"

echo "Installation completed. Check 'install_errors.log' for any issues."

# Python libs installs

FILE="python_libs.txt"

if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

echo "Updating pip..."
python -m pip install --upgrade pip

echo "Installing Python packages..."
while IFS= read -r package || [[ -n "$package" ]]; do
    if [[ ! -z "$package" && ! "$package" =~ ^# ]]; then
        echo "Installing: $package"
        if ! python -m pip install "$package"; then
            echo "Error installing: $package" >> install_errors.log
        fi
    fi
done < "$FILE"

echo "Installation completed. Check 'install_errors.log' for any issues."

# Aliases config

echo "alias ll='ls -alF'" >> ~/.bashrc
echo "alias la='ls -A'" >> ~/.bashrc
echo "alias l='ls -CF'" >> ~/.bashrc
echo "alias bat='batcat'" >> ~/.bashrc
echo "alias cop='eval \$(history -p !!) | xclip -selection clipboard'" >> ~/.bashrc

# Adding openai key to bashrc
echo "Please enter your OpenAI API key:"
read openai_key

if [ -z "$openai_key" ]; then
  echo "API key cannot be empty. Exiting."
  exit 1
fi

echo "export OPENAI_API_KEY=\"$openai_key\"" >> ~/.bashrc
source ~/.bashrc
echo "OpenAI API key has been added to your .bashrc file."

# Adding gpt script

SCRIPT_PATH="$(realpath "$(dirname "$0")/gpt.sh")"

ALIAS_LINE="alias gpt='$SCRIPT_PATH'"

sed -i '/^alias gpt=/d' ~/.bashrc

echo "$ALIAS_LINE" >> ~/.bashrc
echo "Alias 'gpt' added to ~/.bashrc"
source ~/.bashrc
echo "Installation complete! You can now use the 'gpt' command."

# Adding alias commands
echo "alias commands='bat \"$(realpath commands.txt)\"'" >> ~/.bashrc && source ~/.bashrc