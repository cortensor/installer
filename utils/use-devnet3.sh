#!/bin/bash

# This script updates the CONTRACT_ADDRESS_RUNTIME in the .env file.

# Define the path to the .env file
ENV_FILE="$HOME/.cortensor/.env"
SERVICE_FILE="/etc/systemd/system/cortensor.service"

# New contract address (set this variable)
NEW_ADDRESS="0x5889b0E1620f133eFB93fab890543569DE846365"

# Check if the .env file exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: .env file not found at $ENV_FILE."
    exit 1
fi

# Validate the address format (basic check for 0x-prefixed and 42 characters long)
if [[ ! $NEW_ADDRESS =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    echo "Error: Invalid Ethereum address format. Please provide a valid address."
    exit 1
fi

# Use sed to update the line in the .env file
if sed -i.bak -E "s/^CONTRACT_ADDRESS_RUNTIME=\"0x[a-fA-F0-9]{40}\"/CONTRACT_ADDRESS_RUNTIME=\"$NEW_ADDRESS\"/" "$ENV_FILE"; then
    echo "CONTRACT_ADDRESS_RUNTIME updated successfully in $ENV_FILE."
else
    echo "Error: Failed to update the .env file."
    exit 1
fi

# Optionally display the updated line for confirmation
UPDATED_LINE=$(grep "^CONTRACT_ADDRESS_RUNTIME=" "$ENV_FILE")
echo "Updated line: $UPDATED_LINE"

# Check if the systemd service file exists
if [[ ! -f "$SERVICE_FILE" ]]; then
    echo "Error: cortensor.service file not found at $SERVICE_FILE."
    exit 1
fi

# Update the ExecStart line in the systemd service file
sudo sed -i.bak -E "s|^ExecStart=.*|ExecStart=/usr/local/bin/cortensord .env minerv2 1 docker|" "$SERVICE_FILE"
if [[ $? -eq 0 ]]; then
    echo "ExecStart line updated successfully in $SERVICE_FILE."
else
    echo "Error: Failed to update the ExecStart line in $SERVICE_FILE."
    exit 1
fi

# Reload the systemd daemon and restart the service
echo "Reloading systemd daemon and restarting cortensor service..."
sudo systemctl daemon-reload
sudo systemctl restart cortensor.service

if [[ $? -eq 0 ]]; then
    echo "Cortensor service restarted successfully."
else
    echo "Error: Failed to restart cortensor service."
    exit 1
fi
