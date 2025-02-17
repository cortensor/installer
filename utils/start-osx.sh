#!/bin/bash

# This script starts the Cortensor daemon service using nohup on macOS.

# Add ~/.cortensor/bin to PATH explicitly
export PATH="$HOME/.cortensor/bin:$PATH"

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Cortensor daemon..."

# Check for existing Cortensor or APE processes
echo "Checking for running Cortensor and related processes..."

if pgrep -f "cortensord" > /dev/null || pgrep -f "\.ape-1\.10" > /dev/null; then
    echo "Detected running Cortensor or related processes."
    echo "Please stop them using the 'stop-cortensor.sh' script before starting a new instance."
    exit 1
else
    echo "No running Cortensor or related processes found."
fi

# Create logs directory if it doesn't exist
mkdir -p "$HOME/.cortensor/logs"

# Navigate to the .cortensor directory
cd $HOME/.cortensor

# Start the cortensord using nohup
echo "Starting Cortensord..."
nohup cortensord $HOME/.cortensor/.env minerv2 > "$HOME/.cortensor/logs/cortensord.log" 2>&1 &

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
