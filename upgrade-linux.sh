#!/bin/bash

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Define paths
BINARY_PATH="/usr/local/bin/cortensord"
DIST_BINARY="$DIR/dist/cortensord"

echo "Starting Cortensor upgrade process..."
echo "========================================="

# Check if the dist binary exists
if [ ! -f "$DIST_BINARY" ]; then
    echo "Error: Cortensor binary not found in $DIST_BINARY. Upgrade aborted."
    exit 1
fi

# Stop the Cortensor daemon if it's running
echo "1. Stopping the Cortensor daemon service..."
if sudo systemctl stop cortensor; then
    echo "   - Cortensor service stopped successfully."
else
    echo "   - Failed to stop Cortensor service. It may not be running."
fi

# Back up the existing binary
if [ -f "$BINARY_PATH" ]; then
    BACKUP_PATH="$BINARY_PATH.bak_$(date +%Y%m%d_%H%M%S)"
    echo "2. Backing up existing binary to $BACKUP_PATH..."
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
echo "3. Upgrading Cortensor binary..."
sudo cp -f "$DIST_BINARY" "$BINARY_PATH"
if [ $? -eq 0 ]; then
    echo "   - Cortensor binary upgraded successfully."
    sudo chmod +x "$BINARY_PATH"
else
    echo "   - Failed to upgrade Cortensor binary. Upgrade aborted."
    exit 1
fi

# Restart the Cortensor daemon
echo "4. Restarting the Cortensor daemon service..."
if sudo systemctl start cortensor; then
    echo "   - Cortensor service restarted successfully."
else
    echo "   - Failed to restart Cortensor service. Please check the logs for details."
    exit 1
fi

echo "========================================="
echo "Cortensor upgrade process completed successfully!"
