#!/bin/bash

# This script stops the Cortensor daemon service.

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Stopping Cortensor daemon..."
# Attempt to stop the Cortensor daemon using systemd
if sudo systemctl stop cortensord; then
    echo "Cortensord stopped successfully."
else
    echo "Failed to stop Cortensord. It may not be running or require further investigation."
    exit 1 # Exit with an error status if the stop command fails
fi
