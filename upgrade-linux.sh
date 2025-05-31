#!/bin/bash

# Cortensor Node Linux Upgrade Script
# This script upgrades Cortensor node components on Linux systems.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Define paths
BINARY_PATH="/usr/local/bin/cortensord"
START_SCRIPT_PATH="$HOME/.cortensor/bin/start-cortensor.sh"
STOP_SCRIPT_PATH="$HOME/.cortensor/bin/stop-cortensor.sh"

DIST_BINARY="$DIR/dist/cortensord"
ENV_PATH="$HOME/.cortensor/.env"
DIST_ENV="$DIR/dist/.env-example"
SYSTEMD_SERVICE_PATH="/etc/systemd/system/cortensor.service"
DIST_SYSTEMD_SERVICE="$DIR/dist/cortensor.service"
CORTENSOR_BIN_DIR="$HOME/.cortensor/bin"

echo "Starting Cortensor upgrade process..."
echo "========================================="

# Stop the Cortensor daemon using systemctl and pkill
echo "1. Stopping the Cortensor daemon service..."
if sudo systemctl stop cortensor; then
    echo "   - Cortensor service stopped successfully."
else
    echo "   - Failed to stop Cortensor service via systemctl. It may not be running."
fi

echo "2. Killing any running cortensord and ipfs processes..."
pkill -f cortensord && echo "   - Killed cortensord processes." || echo "   - No cortensord processes running."
pkill -f ipfs && echo "   - Killed ipfs processes." || echo "   - No ipfs processes running."

# Back up the existing binary
if [ -f "$BINARY_PATH" ]; then
    BACKUP_PATH="$BINARY_PATH.bak_$(date +%Y%m%d_%H%M%S)"
    echo "3. Backing up existing binary to $BACKUP_PATH..."
    sudo cp "$BINARY_PATH" "$BACKUP_PATH"
    if [ $? -eq 0 ]; then
        echo "   - Backup created successfully."
    else
        echo "   - Failed to create backup. Upgrade aborted."
        exit 1
    fi
else
    echo "   - No existing Cortensor binary found. Skipping backup step."
fi

# Copy the new binary to the target location
echo "4. Upgrading Cortensor binary..."
sudo -u deploy mkdir -p ${CORTENSOR_BIN_DIR}
#sudo cp -f "$DIST_BINARY" "$BINARY_PATH"
#sudo chmod +x "$BINARY_PATH"
sudo cp -f "$DIST_BINARY" /usr/local/bin/cortensord
sudo chmod +x /usr/local/bin/cortensord
sudo ln -sfn /usr/local/bin/cortensord ${CORTENSOR_BIN_DIR}/cortensord

cp -f "$DIR/utils/start-linux.sh" "$START_SCRIPT_PATH"
cp -f "$DIR/utils/stop-linux.sh" "$STOP_SCRIPT_PATH"

if [ $? -eq 0 ]; then
    echo "   - Cortensor binary upgraded successfully."
    sudo chmod +x "$BINARY_PATH"
    sudo chmod +x "$START_SCRIPT_PATH"
    sudo chmod +x "$STOP_SCRIPT_PATH"
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

# Copy the systemd service file
if [ -f "$DIST_SYSTEMD_SERVICE" ]; then
    echo "6. Copying systemd service file..."
    SYSTEMD_BACKUP_PATH="$SYSTEMD_SERVICE_PATH.bak_$(date +%Y%m%d_%H%M%S)"
    if [ -f "$SYSTEMD_SERVICE_PATH" ]; then
        sudo cp "$SYSTEMD_SERVICE_PATH" "$SYSTEMD_BACKUP_PATH"
        echo "   - Existing systemd service file backed up to $SYSTEMD_BACKUP_PATH."
    fi
    sudo cp -f "$DIST_SYSTEMD_SERVICE" "$SYSTEMD_SERVICE_PATH"
    if [ $? -eq 0 ]; then
        echo "   - Systemd service file upgraded successfully."
        sudo systemctl daemon-reload
    else
        echo "   - Failed to upgrade systemd service file. Upgrade aborted."
        exit 1
    fi
else
    echo "   - No systemd service file found in $DIST_SYSTEMD_SERVICE. Skipping this step."
fi

# Restart the Cortensor daemon
echo "7. Restarting the Cortensor daemon service..."
if sudo systemctl start cortensor; then
    echo "   - Cortensor service restarted successfully."
else
    echo "   - Failed to restart Cortensor service. Please check the logs for details."
    exit 1
fi

echo "========================================="
echo "Cortensor upgrade process completed successfully!"
echo ""
echo "Recommended Usage:"
echo "  - To start Cortensor:  sudo systemctl start cortensor"
echo "  - To stop Cortensor:   sudo systemctl stop cortensor"
echo ""
echo "Manual Usage (not recommended):"
echo "  - To start Cortensor manually:  ${CORTENSOR_BIN_DIR}/start-cortensor.sh"
echo "  - To stop Cortensor manually:   ${CORTENSOR_BIN_DIR}/stop-cortensor.sh"
echo ""
echo "Logs are available in: ${CORTENSOR_LOGS}/"
echo "  - /var/log/cortensor/cortensord.log"
echo ""
echo "Note: Using systemctl is the recommended approach for managing the Cortensor service."
echo "      You may need to restart your terminal or update the PATH variable to include:"
echo "      ${CORTENSOR_BIN_DIR}"