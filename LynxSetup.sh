#!/bin/bash
REPO_URL="https://github.com/SwarJagdale/LynxCLI.git"
# Directory where LynxCLI will be saved
REPO_DIR="$HOME/LynxCLI"

# Clone the GitHub repository
git clone "$REPO_URL" "$REPO_DIR"

# Check if the repository was cloned successfully
if [ $? -eq 0 ]; then
    echo "Repository cloned successfully."
    
    # Make all shell scripts executable within the repository directory
    find "$REPO_DIR" -type f -name "*.sh" -exec chmod +x {} \;
if [ ! -f '~/.bashrc' ]; then
touch ~/.bashrc
fi
    # Create an alias for running ./lynx.sh as 'lynxcli'
   
    if ! grep -q "alias lynxcli='$REPO_DIR/lynx.sh'" ~/.bashrc; then
   
    echo "alias lynxcli='$REPO_DIR/lynx.sh'" >> ~/.bashrc
    echo "Alias 'lynxcli' appended to ~/.bashrc."
else
    echo "Alias 'lynxcli' already exists in ~/.bashrc. Skipping."
fi

    source ~/.bashrc

    echo "Environment variable and alias set up. You can now use 'lynxcli' to run ./lynx.sh."

else
    echo "Error: Cloning repository failed."
fi
