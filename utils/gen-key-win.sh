#!/bin/bash

# This script generates a new key using the Cortensor tool.

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Export the Cortensor environment paths
export PATH=$HOME/.cortensor/bin:$HOME/.cortensor/llm-files:$PATH

# Change to the Cortensor configuration directory
echo "Navigating to Cortensor configuration directory..."
cd ~/.cortensor || { echo "Failed to navigate to ~/.cortensor. Directory not found."; exit 1; }

# Check if the .env file exists
if [[ -f ".env" ]]; then
    echo "The .env file already exists."
    # Prompt the user for backup
    read -p "Do you want to back up the existing .env file before generating a new key? (y/n): " choice
    case "$choice" in
        [Yy]* )
            # Create a backup with a timestamp
            backup_file=".env.backup.$(date +%Y%m%d%H%M%S)"
            cp .env "$backup_file"
            echo "Backup created: $backup_file"
            ;;
        [Nn]* )
            echo "Proceeding without backup..."
            ;;
        * )
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
fi

# Execute the Cortensor tool to generate a new key
echo "Generating a new key using Cortensor tool..."
if cortensord.exe ~/.cortensor/.env tool gen_key; then
    echo "Key generated successfully."
else
    echo "Failed to generate key. Please check the configuration or environment setup."
    exit 1
fi
