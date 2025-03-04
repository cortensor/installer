#!/bin/bash

# This script toggles GPU support by updating the .env file.
# If running on Linux, it also updates the systemd service file.

# Define file paths
ENV_FILE="$HOME/.cortensor/.env"
SERVICE_FILE="/etc/systemd/system/cortensor.service"
GPU_SERVICE_FILE="./dist/cortensor.subprocess.service"
DEFAULT_SERVICE_FILE="./dist/cortensor.service"

# Detect OS type
OS_TYPE=$(uname -s)

# Check if the .env file exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: .env file not found at $ENV_FILE."
    exit 1
fi

# Check current GPU mode
CURRENT_GPU_MODE=$(grep "^LLM_OPTION_GPU=" "$ENV_FILE" | cut -d '=' -f2)

# Toggle GPU mode
if [[ "$CURRENT_GPU_MODE" == "1" ]]; then
    echo "Disabling GPU mode..."
    NEW_GPU_MODE=0
    SERVICE_TO_USE="$DEFAULT_SERVICE_FILE"
else
    echo "Enabling GPU mode..."
    NEW_GPU_MODE=1
    SERVICE_TO_USE="$GPU_SERVICE_FILE"
fi

# Update the LLM_OPTION_GPU variable in the .env file
if grep -q "^LLM_OPTION_GPU=" "$ENV_FILE"; then
    sed -i.bak -E "s/^LLM_OPTION_GPU=[0-9]+/LLM_OPTION_GPU=$NEW_GPU_MODE/" "$ENV_FILE"
    echo "Updated LLM_OPTION_GPU=$NEW_GPU_MODE in $ENV_FILE."
else
    echo "LLM_OPTION_GPU=$NEW_GPU_MODE" >> "$ENV_FILE"
    echo "Added LLM_OPTION_GPU=$NEW_GPU_MODE to $ENV_FILE."
fi

# If running on Linux, update systemd service file
if [[ "$OS_TYPE" == "Linux" ]]; then
    echo "Linux detected: Updating systemd service file."

    # Check if the systemd service files exist
    if [[ ! -f "$GPU_SERVICE_FILE" ]]; then
        echo "Error: GPU systemd service file not found at $GPU_SERVICE_FILE."
        exit 1
    fi

    if [[ ! -f "$DEFAULT_SERVICE_FILE" ]]; then
        echo "Error: Default systemd service file not found at $DEFAULT_SERVICE_FILE."
        exit 1
    fi

    # Replace the systemd service file
    sudo cp "$SERVICE_TO_USE" "$SERVICE_FILE"

    if [[ $? -eq 0 ]]; then
        echo "Replaced $SERVICE_FILE with $(basename "$SERVICE_TO_USE")."
    else
        echo "Error: Failed to replace systemd service file."
        exit 1
    fi

    # Reload systemd daemon and restart the service
    echo "Reloading systemd daemon and restarting cortensor service..."
    sudo systemctl daemon-reload
    sudo systemctl restart cortensor.service

    if [[ $? -eq 0 ]]; then
        echo "Cortensor service restarted successfully with GPU mode set to $NEW_GPU_MODE."
    else
        echo "Error: Failed to restart cortensor service."
        exit 1
    fi
else
    echo "Non-Linux system detected: Only updating .env file."
fi

echo "GPU mode toggle complete."
