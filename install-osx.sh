#!/bin/bash

# Cortensor Node macOS Installer
# This script installs and configures Cortensor node components on macOS systems.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "Starting Cortensor installation process..."
echo "========================================="

echo "1. Setting up directory structure"
# Create necessary directories
mkdir -p ~/.cortensor/bin
mkdir -p ~/.cortensor/logs
mkdir -p ~/.cortensor/bin/llm-files

echo "2. Deploying the Cortensor daemon executable"
# Copy the darwin (macOS) specific Cortensor daemon executable
cp dist/cortensord-darwin-amd64 ~/.cortensor/bin/cortensord
chmod +x ~/.cortensor/bin/cortensord
echo "   - Cortensor daemon copied to ~/.cortensor/bin and made executable"

echo "3. Copying start and stop scripts"
cp utils/start-osx.sh ~/.cortensor/bin/start-cortensor.sh
cp utils/stop-osx.sh ~/.cortensor/bin/stop-cortensor.sh
chmod +x ~/.cortensor/bin/start-cortensor.sh
chmod +x ~/.cortensor/bin/stop-cortensor.sh
echo "   - Start and stop scripts copied to ~/.cortensor/bin and made executable"

echo "4. Setting up LLM integration"
echo "   - Directory ~/.cortensor/bin/llm-files created"

echo "5. Copying environment configuration file"
cp dist/.env-example ~/.cortensor/.env
echo "   - Example environment file copied to ~/.cortensor/.env"

echo "6. Creating log files"
touch ~/.cortensor/logs/cortensord.log
touch ~/.cortensor/logs/cortensord-llm.log
echo "   - Log files created in ~/.cortensor/logs/"

echo "7. Adding ~/.cortensor/bin directory to PATH"
# Add ~/.cortensor/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.cortensor/bin:"* ]]; then
    echo 'export PATH="$HOME/.cortensor/bin:$PATH"' >> ~/.zshrc
    echo 'export PATH="$HOME/.cortensor/bin:$PATH"' >> ~/.bash_profile
    echo "   - Added ~/.cortensor/bin to PATH in shell configuration files"
fi

echo "========================================="
echo "Cortensor installation completed successfully!"
echo ""
echo "Usage:"
echo "  - To start Cortensor:  ~/.cortensor/bin/start-cortensor.sh"
echo "  - To stop Cortensor:   ~/.cortensor/bin/stop-cortensor.sh"
echo "  - Logs are available in: ~/.cortensor/logs/"
echo ""
echo "Note: You may need to restart your terminal or run 'source ~/.zshrc'"
echo "      (or ~/.bash_profile) to use the commands immediately."
