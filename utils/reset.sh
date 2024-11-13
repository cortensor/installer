#!/bin/bash

# Navigate to the script directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remove the Cortensor configuration directory and all logs
echo "Removing Cortensor configuration and logs..."
sudo rm -Rf /home/deploy/.cortensor
sudo rm -f /var/log/cortensord.log
sudo rm -f /var/log/cortensord-llm.log

# Remove the Cortensor executable and service files
echo "Removing Cortensor executable and service definition..."
sudo rm -f /usr/local/bin/cortensord
sudo rm -f /etc/systemd/system/cortensord.service

# Reload systemd to apply changes
echo "Reloading systemd..."
sudo systemctl daemon-reload
echo "Reset complete."
