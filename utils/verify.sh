#!/bin/bash

# This script generates a new key using the Cortensor tool.

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Export the Cortensor environment paths
export PATH=$HOME/.cortensor/bin:$HOME/.cortensor/llm-files:/usr/local/bin/:$PATH

# Change to the Cortensor configuration directory
echo "Navigating to Cortensor configuration directory..."
cd ~/.cortensor || { echo "Failed to navigate to ~/.cortensor. Directory not found."; exit 1; }

# Execute the Cortensor tool to generate a new key
echo "Verifying using cortensord tool..."
if cortensord ~/.cortensor/.env tool verify; then
    echo "Verified successfully."
else
    echo "Failed to verify. Please check the configuration or environment setup."
    exit 1
fi
