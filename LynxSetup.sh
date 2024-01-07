#!/bin/bash

# Your GitHub repository URL
REPO_URL="https://github.com/SwarJagdale/LynxCLI.git"

# Directory where the repository will be cloned
REPO_DIR="LynxCLI"

# Clone the GitHub repository
git clone "$REPO_URL" "$REPO_DIR"

# Check if the repository was cloned successfully
if [ $? -eq 0 ]; then
    echo "Repository cloned successfully."

    # Set up environment variable
    echo "export LYNX_REPO_DIR=$(pwd)/$REPO_DIR" >> ~/.bashrc
    source ~/.bashrc

    # Create an alias for running ./lynx.sh as 'lynx'
    echo "alias lynx='cd \$LYNX_REPO_DIR && ./lynx.sh'" >> ~/.bashrc
    source ~/.bashrc

    echo "Environment variable and alias set up. You can now use 'lynx' to run ./lynx.sh."

else
    echo "Error: Cloning repository failed."
fi
