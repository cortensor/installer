#!/bin/bash

# This script resets the Cortensor setup by removing its configuration, logs, executable, and service files.

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remove the Cortensor configuration and log files
echo "Removing Cortensor configuration and logs..."
if sudo rm -Rf /home/deploy/.cortensor; then
    echo "Configuration directory removed successfully."
else
    echo "Failed to remove the configuration directory. Please check permissions."
fi

if sudo rm -f /var/log/cortensord.log; then
    echo "Log file cortensord.log removed successfully."
else
    echo "Failed to remove cortensord.log. Please check permissions."
fi

if sudo rm -f /var/log/cortensord-llm.log; then
    echo "Log file cortensord-llm.log removed successfully."
else
    echo "Failed to remove cortensord-llm.log. Please check permissions."
fi

# Remove the Cortensor executable and service files
echo "Removing Cortensor executable and service definition..."
if sudo rm -f /usr/local/bin/cortensord; then
    echo "Cortensor executable removed successfully."
else
    echo "Failed to remove the executable. Please check permissions."
fi

if sudo rm -f /etc/systemd/system/cortensord.service; then
    echo "Cortensor service file removed successfully."
else
    echo "Failed to remove the service file. Please check permissions."
fi

# Reload systemd to apply changes
echo "Reloading systemd..."
if sudo systemctl daemon-reload; then
    echo "Systemd reloaded successfully."
else
    echo "Failed to reload systemd. Please check systemd status."
fi

echo "Reset complete."
