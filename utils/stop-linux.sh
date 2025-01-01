#!/bin/bash

# This script stops the Cortensor daemon service and related processes.

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Stopping Cortensor daemon and related processes..."

# Step 1: Attempt to stop the Cortensor daemon using systemd
if sudo systemctl stop cortensor; then
    echo "Cortensord stopped successfully using systemd."
else
    echo "Failed to stop Cortensord using systemd. Proceeding to manually terminate processes..."
fi

# Step 2: Check and terminate any remaining cortensord processes
if pgrep -f "cortensord" > /dev/null; then
    echo "Detected running cortensord processes. Attempting to kill them..."
    pgrep -f "cortensord" | xargs kill -9
    echo "All remaining cortensord processes have been terminated."
else
    echo "No running cortensord processes found."
fi

# Step 3: Check and terminate any remaining ipfs processes
if pgrep -f "ipfs" > /dev/null; then
    echo "Detected running ipfs processes. Attempting to kill them..."
    pgrep -f "ipfs" | xargs kill -9
    echo "All remaining ipfs processes have been terminated."
else
    echo "No running ipfs processes found."
fi

# Verify all processes are stopped
if pgrep -f "cortensord|ipfs" > /dev/null; then
    echo "Warning: Some processes may still be running. Please check manually."
    exit 1
else
    echo "All Cortensor-related processes stopped successfully."
    exit 0
fi
