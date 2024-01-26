#!/bin/bash
REPO_URL="https://github.com/SwarJagdale/LynxCLI.git"
#Directory where lynxCLI will be saved
REPO_DIR="$HOME/LynxCLI"

git clone "$REPO_URL" "$REPO_DIR"

# Check if the repository was cloned successfully
if [ $? -eq 0 ]; then
    echo "Repository cloned successfully."
    
    # Create an alias for running ./lynx.sh as 'lynxcli'
    echo "alias lynxcli=$REPO_DIR/lynx.sh'" >> ~/.bashrc

    source ~/.bashrc

    echo "Environment variable and alias set up. You can now use 'lynxcli' to run ./lynx.sh."

else
    echo "Error: Cloning repository failed."
fi
