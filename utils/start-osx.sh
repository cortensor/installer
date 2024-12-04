#!/bin/bash

# This script starts the Cortensor daemon service using nohup on macOS.

# Add ~/bin to PATH explicitly
export PATH="$HOME/bin:$PATH"

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Cortensor daemon..."

# Check if process is already running
if pgrep -f "cortensord" > /dev/null; then
    echo "Cortensord is already running."
    exit 0
fi

# Create logs directory if it doesn't exist
mkdir -p "$HOME/.cortensor/logs"

# Move to .cortensor
cd $HOME/.cortensor

# Start the cortensord using nohup
nohup cortensord $HOME/.cortensor/.env minerv1 > "$HOME/.cortensor/logs/cortensord.log" 2>&1 &

# Get the PID of the new process
PID=$!

# Wait a moment to see if the process is still running
sleep 2

if ps -p $PID > /dev/null; then
    echo "Cortensord started successfully. PID: $PID"
    echo "Logs are available at: $HOME/.cortensor/logs/cortensord.log"
else
    echo "Failed to start Cortensord. Please check the logs for more details."
    exit 1
fi

# Save PID to a file for later use
echo $PID > "$HOME/.cortensor/cortensord.pid"