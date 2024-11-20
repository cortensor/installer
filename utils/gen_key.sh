#!/bin/bash

# This script generates a new key using the Cortensor tool.

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the Cortensor configuration directory
echo "Navigating to Cortensor configuration directory..."
cd ~/.cortensor || { echo "Failed to navigate to ~/.cortensor. Directory not found."; exit 1; }

# Execute the Cortensor tool to generate a new key
echo "Generating a new key using cortensord tool..."
if /usr/local/bin/cortensord ~/.cortensor/.env tool gen_key; then
    echo "Key generated successfully."
else
    echo "Failed to generate key. Please check the configuration or environment setup."
    exit 1
fi
