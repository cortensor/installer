#!/bin/bash

# This script starts the Cortensor daemon service.

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Cortensor daemon..."
# Attempt to start the Cortensor daemon using systemd
if sudo systemctl start cortensord; then
    echo "Cortensord started successfully."
else
    echo "Failed to start Cortensord. Please check the service status for more details."
    exit 1 # Exit with an error status if the start command fails
fi
