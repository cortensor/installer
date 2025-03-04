#!/bin/bash

# This script starts the Cortensor daemon service using nohup on macOS.

# Add ~/.cortensor/bin to PATH explicitly
export PATH="$HOME/.cortensor/bin:$PATH"

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Cortensor daemon..."

# Check for existing Cortensor or APE processes
echo "Checking for running Cortensor and APE processes..."

if pgrep -f "cortensord" > /dev/null || pgrep -f "\.ape-1\.10" > /dev/null; then
    echo "Detected running Cortensor or APE processes."
    echo "Please stop them using the 'stop-cortensor.sh' script before starting a new instance."
    exit 1
else
    echo "No running Cortensor or APE processes found."
fi

# Create logs directory if it doesn't exist
mkdir -p "$HOME/.cortensor/logs"

# Navigate to the .cortensor directory
cd "$HOME/.cortensor"

# Check if GPU mode is enabled
GPU_MODE=$(grep "^LLM_OPTION_GPU=" "$HOME/.cortensor/.env" | cut -d '=' -f2)

# Set the appropriate command based on GPU mode
if [[ "$GPU_MODE" == "1" ]]; then
    echo "GPU mode enabled. Starting Cortensor without '1 docker' argument."
    CMD="nohup cortensord $HOME/.cortensor/.env minerv2 > \"$HOME/.cortensor/logs/cortensord.log\" 2>&1 &"
else
    echo "GPU mode disabled. Starting Cortensor with '1 docker' argument."
    CMD="nohup cortensord $HOME/.cortensor/.env minerv2 1 docker > \"$HOME/.cortensor/logs/cortensord.log\" 2>&1 &"
fi

# Run the determined command
eval "$CMD"

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
