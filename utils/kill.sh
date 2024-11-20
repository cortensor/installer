#!/bin/bash

# This script terminates the Cortensor daemon process gracefully.

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Terminate the Cortensor daemon
echo "Terminating cortensord process..."
if pkill -15 cortensord; then
    echo "Cortensord process terminated successfully."
else
    echo "Failed to terminate cortensord. It may not be running or you may not have sufficient permissions."
fi
