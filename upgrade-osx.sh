#!/bin/bash

# Cortensor Node macOS Upgrade Script
# This script upgrades Cortensor node components on macOS systems.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Define paths
CORTENSOR_BIN="$HOME/.cortensor/bin/cortensord"
START_SCRIPT_PATH="$HOME/.cortensor/bin/start-cortensor.sh"
STOP_SCRIPT_PATH="$HOME/.cortensor/bin/stop-cortensor.sh"

DIST_BINARY="$DIR/dist/cortensord-darwin"
ENV_PATH="$HOME/.cortensor/.env"
DIST_ENV="$DIR/dist/.env-example"

echo "Starting Cortensor upgrade process for macOS..."
echo "========================================="

# Stop the Cortensor daemon using the stop script
echo "1. Stopping Cortensor daemon..."
if [ -f "$HOME/bin/stop-cortensor.sh" ]; then
    "$HOME/bin/stop-cortensor.sh"
    echo "   - Stop script executed."
else
    echo "   - Stop script not found. Proceeding to kill processes directly."
fi

# Kill any remaining cortensord and ipfs processes
echo "2. Killing any running cortensord and ipfs processes..."
pkill -f cortensord && echo "   - Killed cortensord processes." || echo "   - No cortensord processes running."
pkill -f ipfs && echo "   - Killed ipfs processes." || echo "   - No ipfs processes running."

# Back up the existing binary
if [ -f "$CORTENSOR_BIN" ]; then
    BACKUP_PATH="$CORTENSOR_BIN.bak_$(date +%Y%m%d_%H%M%S)"
    echo "3. Backing up existing binary to $BACKUP_PATH..."
    mv "$CORTENSOR_BIN" "$BACKUP_PATH"
    if [ $? -eq 0 ]; then
        echo "   - Backup created successfully."
    else
        echo "   - Failed to create backup. Upgrade aborted."
        exit 1
    fi
else
    echo "   - No existing Cortensor binary found. Skipping backup step."
fi

# Copy the new binary to the bin directory
echo "4. Upgrading Cortensor binary..."
mkdir -p "$HOME/.cortensor/bin"
cp -f "$DIST_BINARY" "$CORTENSOR_BIN"
cp -f "$DIR/utils/start-osx.sh" "$START_SCRIPT_PATH"
cp -f "$DIR/utils/stop-osx.sh" "$STOP_SCRIPT_PATH"
if [ $? -eq 0 ]; then
    echo "   - Cortensor binary upgraded successfully."
    chmod +x "$CORTENSOR_BIN"
    chmod +x "$START_SCRIPT_PATH"
    chmod +x "$STOP_SCRIPT_PATH"
else
    echo "   - Failed to upgrade Cortensor binary. Upgrade aborted."
    exit 1
fi

# Handle the .env file
echo "5. Handling .env file upgrade..."
if [ -f "$ENV_PATH" ]; then
    echo "   - Existing .env file detected at $ENV_PATH."
    echo "Do you want to:"
    echo "1) Keep the existing .env file"
    echo "2) Replace it with the new .env-example file (existing .env will be backed up)"
    read -p "Enter your choice (1 or 2): " choice
    case "$choice" in
        1)
            echo "   - Keeping the existing .env file."
            ;;
        2)
            ENV_BACKUP_PATH="$ENV_PATH.bak_$(date +%Y%m%d_%H%M%S)"
            cp "$ENV_PATH" "$ENV_BACKUP_PATH"
            echo "   - Existing .env file backed up to $ENV_BACKUP_PATH."
            cp -f "$DIST_ENV" "$ENV_PATH"
            echo "   - New .env file copied to $ENV_PATH."
            ;;
        *)
            echo "Invalid choice. Aborting upgrade process."
            exit 1
            ;;
    esac
else
    echo "   - No existing .env file detected."
    cp "$DIST_ENV" "$ENV_PATH"
    echo "   - New .env file copied to $ENV_PATH."
fi

echo "6. Upgrading start and stop scripts..."
if [ -f "$DIR/utils/start-osx.sh" ] && [ -f "$DIR/utils/stop-osx.sh" ]; then
    cp "$DIR/utils/start-osx.sh" "$HOME/bin/start-cortensor.sh"
    cp "$DIR/utils/stop-osx.sh" "$HOME/bin/stop-cortensor.sh"
    chmod +x "$HOME/bin/start-cortensor.sh"
    chmod +x "$HOME/bin/stop-cortensor.sh"
    echo "   - Start and stop scripts upgraded successfully."
else
    echo "   - Start and stop scripts not found in utils folder. Skipping this step."
fi

# Restart instructions
echo "========================================="
echo "Cortensor upgrade process completed successfully!"
echo ""
echo "Usage:"
echo "  - To start Cortensor:  ~/.cortensor/bin/start-cortensor.sh"
echo "  - To stop Cortensor:   ~/.cortensor/bin/stop-cortensor.sh"
echo "  - Logs are available in: ~/.cortensor/logs/"
echo ""
echo "Note: You may need to restart your terminal or run 'source ~/.zshrc'"
echo "      (or ~/.bash_profile) to use the commands immediately."