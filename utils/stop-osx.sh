#!/bin/bash

# This script stops the Cortensor daemon service and related processes on Linux.

# Add ~/.cortensor/bin to PATH explicitly
export PATH="$HOME/.cortensor/bin:$PATH"

echo "Stopping Cortensor daemon and related processes..."

# Try to get PID from the PID file first
PID_FILE="$HOME/.cortensor/cortensord.pid"
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null; then
        kill "$PID"
        rm -f "$PID_FILE"
        echo "Cortensord process from PID file stopped."
    fi
fi

# Use pkill for cortensord (catch any remaining processes)
if pkill -f cortensord; then
    echo "Cortensord processes stopped using pkill."
else
    echo "No running Cortensord processes found with pkill."
fi

# Use pkill for .ape processes
if pkill -f "\.ape-1\.10"; then
    echo ".ape-1.10 processes stopped using pkill."
else
    echo "No running .ape-1.10 processes found with pkill."
fi

# Fallback: Use ps and grep to find and kill processes if pkill failed
echo "Performing additional checks for lingering processes..."

CORTENSOR_PIDS=$(ps -ef | grep 'cortensord' | grep -v grep | awk '{print $2}')
if [ -n "$CORTENSOR_PIDS" ]; then
    echo "   - Found Cortensord process IDs: $CORTENSOR_PIDS. Terminating..."
    echo "$CORTENSOR_PIDS" | xargs kill -9
    echo "   - Cortensord processes terminated."
else
    echo "   - No additional Cortensord processes found."
fi

APE_PIDS=$(ps -ef | grep '\.ape-1\.10' | grep -v grep | awk '{print $2}')
if [ -n "$APE_PIDS" ]; then
    echo "   - Found .ape-1.10 process IDs: $APE_PIDS. Terminating..."
    echo "$APE_PIDS" | xargs kill -9
    echo "   - .ape-1.10 processes terminated."
else
    echo "   - No additional .ape-1.10 processes found."
fi

IPFS_PIDS=$(ps -ef | grep 'ipfs' | grep -v grep | awk '{print $2}')
if [ -n "$IPFS_PIDS" ]; then
    echo "   - Found IPFS process IDs: $IPFS_PIDS. Terminating..."
    echo "$IPFS_PIDS" | xargs kill -9
    echo "   - IPFS processes terminated."
else
    echo "   - No additional IPFS processes found."
fi

# Final verification
if pgrep -f "cortensord|\.ape-1\.10" > /dev/null; then
    echo "Warning: Some processes might still be running. Manual intervention may be required."
    exit 1
else
    echo "All Cortensor related processes stopped successfully."
    exit 0
fi
