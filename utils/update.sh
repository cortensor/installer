#!/bin/bash

# This script stops the Cortensor daemon and updates the binary.

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Stopping Cortensor daemon..."
# Stop the systemd service, if it fails, try to kill the process directly.
sudo systemctl stop cortensord || sudo pkill -f cortensord

echo "Updating Cortensor daemon binary..."
# Safely copy the new binary from the distribution folder.
sudo cp -f "$DIR/../dist/cortensord" /usr/local/bin/cortensord

# Check if the copy operation was successful
if [ $? -eq 0 ]; then
    echo "Cortensord updated successfully."
else
    echo "Failed to update Cortensord. Check permissions and file path."
    exit 1 # Exit with an error status
fi
