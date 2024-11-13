#!/bin/bash

# Navigate to the script directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Start the Cortensor daemon
echo "Starting cortensord..."
sudo systemctl start cortensord
