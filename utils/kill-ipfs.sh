#!/bin/bash

# This script terminates the IPFS daemon process gracefully.

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Terminate the IPFS daemon process
echo "Terminating IPFS process..."
if ps -W | grep ipfs | grep -v grep | awk '{print $1}' | xargs kill -15; then
    echo "IPFS process terminated successfully."
else
    echo "Failed to terminate IPFS. It may not be running or you may not have sufficient permissions."
fi
