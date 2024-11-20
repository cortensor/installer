#!/bin/bash

# This script runs the Cortensor tool to retrieve the ID.

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Execute the Cortensor tool with the provided .env file
echo "Retrieving ID using cortensord tool..."
if /usr/local/bin/cortensord /home/deploy/.cortensor/.env tool id; then
    echo "ID retrieved successfully."
else
    echo "Failed to retrieve ID. Please check the configuration or environment setup."
fi
