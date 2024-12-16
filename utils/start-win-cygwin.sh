#!/bin/bash

# This script starts the Cortensor daemon service.

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Export the Cortensor environment paths
export PATH=$HOME/.cortensor/bin:$HOME/.cortensor/llm-files:$PATH

cd $HOME/.cortensor
echo "Starting Cortensor daemon..."

# Start the Cortensor daemon
if cortensord.exe .env minerv1; then
    echo "Cortensord started successfully."
else
    echo "Failed to start Cortensord. Please check the logs or environment setup for more details."
    exit 1 # Exit with an error status if the command fails
fi
