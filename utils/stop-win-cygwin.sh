#!/bin/bash

# This script stops the Cortensor daemon service.

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "Stopping Cortensor daemon..."

# Find the process ID (PID) of cortensord and terminate it
cortensord_pid=$(ps -W | grep cortensord | grep -v grep | awk '{print $1}')

if [[ -n "$cortensord_pid" ]]; then
    echo "Cortensord process found with PID: $cortensord_pid. Terminating..."
    if kill -15 "$cortensord_pid"; then
        echo "Cortensord stopped successfully."
    else
        echo "Failed to stop Cortensord. You may need to terminate it manually."
        exit 1
    fi
else
    echo "Cortensord is not running or the process could not be found."
fi
