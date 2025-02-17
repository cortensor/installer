#!/bin/bash

# This script starts the Cortensor daemon service.

# Navigate to the script's directory to ensure relative paths work.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Export the Cortensor environment paths
export PATH=$HOME/.cortensor/bin:$HOME/.cortensor/llm-files:$PATH

cd $HOME/.cortensor
echo "Starting Cortensor daemon..."
#nohup cortensord .env minerv1 > "$HOME/.cortensor/logs/cortensord.log" 2>&1 &
#PID=$!

#sleep 2

# Start the Cortensor daemon
#if ps -p $PID > /dev/null; then
if cortensord .env minerv2; then
    echo "Cortensord started successfully."
else
    echo "Failed to start Cortensord. Please check the logs or environment setup for more details."
    exit 1 # Exit with an error status if the command fails
fi

# Save PID to a file for later use
# echo $PID > "$HOME/.cortensor/cortensord.pid"