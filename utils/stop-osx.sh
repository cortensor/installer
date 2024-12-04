#!/bin/bash

# This script stops the Cortensor daemon service and related processes on macOS.

# Add ~/bin to PATH explicitly
export PATH="$HOME/bin:$PATH"

echo "Stopping Cortensor daemon and related processes..."

# Try to get PID from file first
PID_FILE="$HOME/.cortensor/cortensord.pid"
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null; then
        kill "$PID"
        rm "$PID_FILE"
        echo "Cortensord process from PID file stopped."
    fi
fi

# Use pkill for cortensord (catch any remaining processes)
if pkill cortensord; then
    echo "Cortensord processes stopped."
fi

# Stop .ape processes
if pkill -f "\.ape-1\.10"; then
    echo ".ape-1.10 processes stopped."
fi

# Final check
if pgrep -f "cortensord|\.ape-1\.10" > /dev/null; then
    echo "Warning: Some processes might still be running. Attempting force kill..."
    pkill -9 cortensord
    pkill -9 -f "\.ape-1\.10"
    sleep 1
fi

# Verify all processes are stopped
if pgrep -f "cortensord|\.ape-1\.10" > /dev/null; then
    echo "Error: Failed to stop all processes."
    exit 1
else
    echo "All Cortensor related processes stopped successfully."
    exit 0
fi