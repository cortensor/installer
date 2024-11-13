#!/bin/bash

# Navigate to the script directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Stop the Cortensor daemon
echo "Stopping cortensord..."
sudo systemctl stop cortensord
