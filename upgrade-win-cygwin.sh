#!/bin/bash

# Cortensor Node Windows Upgrade Script (Cygwin)
# This script upgrades Cortensor node components on Windows systems using Cygwin.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Define paths
CORTENSOR_DIR="$HOME/.cortensor"
BINARY_PATH="$CORTENSOR_DIR/bin/cortensord.exe"

DIST_BINARY="$DIR/dist/cortensord.exe"
ENV_PATH="$CORTENSOR_DIR/.env"
DIST_ENV="$DIR/dist/.env-example"

echo "Starting Cortensor upgrade process for Cygwin on Windows..."
echo "==============================================================="

# Stop the Cortensor daemon using the stop script
echo "1. Stopping Cortensor daemon..."
if [ -f "${CORTENSOR_DIR}/stop-cortensor.sh" ]; then
    "${CORTENSOR_DIR}/stop-cortensor.sh"
    echo "   - Stop script executed."
else
    echo "   - Stop script not found. Proceeding to kill processes directly."
fi

# Kill any remaining cortensord and ipfs processes
echo "2. Killing any running cortensord and ipfs processes..."
CORTENSORD_PID=$(ps -W | grep cortensord.exe | grep -v grep | awk '{print $1}')
if [ -n "$CORTENSORD_PID" ]; then
    echo "   - Found Cortensor process with PID: $CORTENSORD_PID"
    kill -9 "$CORTENSORD_PID" && echo "   - Killed cortensord process." || echo "   - Failed to kill cortensord process."
else
    echo "   - No Cortensor process running."
fi

IPFS_PID=$(ps -W | grep ipfs | grep -v grep | awk '{print $1}')
if [ -n "$IPFS_PID" ]; then
    echo "   - Found IPFS process with PID: $IPFS_PID"
    kill -9 "$IPFS_PID" && echo "   - Killed IPFS process." || echo "   - Failed to kill IPFS process."
else
    echo "   - No IPFS process running."
fi

# Back up the existing binary
if [ -f "$BINARY_PATH" ]; then
    BACKUP_PATH="$BINARY_PATH.bak_$(date +%Y%m%d_%H%M%S)"
    echo "3. Backing up existing binary to $BACKUP_PATH..."
    mv "$BINARY_PATH" "$BACKUP_PATH"
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
cp -f "$DIST_BINARY" "$BINARY_PATH"
if [ $? -eq 0 ]; then
    echo "   - Cortensor binary upgraded successfully."
    chmod +x "$BINARY_PATH"
else
    echo "   - Failed to upgrade Cortensor binary. Upgrade aborted."
    exit 1
fi

# Handle the .env file
echo "5. Handling .env file upgrade..."
if [ -f "$ENV_PATH" ]; then
    echo "   - Existing .env file detected at $ENV_PATH."
    echo "Do you want to:"
    echo "1) Use the existing .env file"
    echo "2) Back up the existing .env file and copy a new one"
    read -p "Enter your choice (1 or 2): " choice
    case "$choice" in
        1)
            echo "   - Keeping the existing .env file."
            ;;
        2)
            ENV_BACKUP_PATH="${ENV_PATH}.bak_$(date +%Y%m%d_%H%M%S)"
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
if [ -f "$DIR/utils/start-win-cygwin.sh" ] && [ -f "$DIR/utils/stop-win-cygwin.sh" ]; then
    cp "$DIR/utils/start-win-cygwin.sh" "${CORTENSOR_DIR}/start-cortensor.sh"
    cp "$DIR/utils/stop-win-cygwin.sh" "${CORTENSOR_DIR}/stop-cortensor.sh"
    chmod +x "${CORTENSOR_DIR}/start-cortensor.sh"
    chmod +x "${CORTENSOR_DIR}/stop-cortensor.sh"
    echo "   - Start and stop scripts upgraded successfully."
else
    echo "   - Start and stop scripts not found in utils folder. Skipping this step."
fi

mkdir -p "${CORTENSOR_DIR}/logs"
echo "   - Created logs directory: ${CORTENSOR_DIR}/logs"
touch "${CORTENSOR_DIR}/logs/cortensord.log"
echo "   - Created log file: ${CORTENSOR_DIR}/logs/cortensord.log"
touch "${CORTENSOR_DIR}/logs/cortensord-llm.log"
echo "   - Created log file: ${CORTENSOR_DIR}/logs/cortensord-llm.log"

# Copy the Windows batch file to the user's desktop
if [[ -f "./utils/start-cortensor.bat" ]]; then
    echo "Copying start-cortensor.bat to Desktop..."
    if [[ -d "$HOME/Desktop" ]]; then
        cp ./utils/start-cortensor.bat "$HOME/Desktop/"
        echo "Copied start-cortensor.bat to Desktop successfully."
    else
        echo "Warning: Desktop directory not found at $HOME/Desktop. Skipping copy."
    fi
else
    echo "Warning: start-cortensor.bat not found in ./utils/. Skipping copy."
fi

# Restart instructions
echo "==============================================================="
echo "Cortensor upgrade process for Cygwin completed successfully!"
echo ""
echo "Usage:"
echo "  - To start Cortensor manually: ~/.cortensor/start-cortensor.sh"
echo "  - To stop Cortensor manually:  ~/.cortensor/stop-cortensor.sh"
echo ""
echo "Note: Ensure the necessary environment variables are configured in ~/.cortensor/.env."
echo "Logs are generated automatically and saved under ~/.cortensor/logs/"
