#!/bin/bash

# This script adjusts permissions for the Docker socket and restarts the Docker service.

echo "Starting Docker socket and service adjustment process..."
echo "======================================================="

echo "1. Updating permissions for the Docker socket"
# Update permissions for the Docker socket
sudo chown root:docker /var/run/docker.sock
if [[ $? -eq 0 ]]; then
    echo "   - Permissions for /var/run/docker.sock updated successfully"
else
    echo "   - Error: Failed to update permissions for /var/run/docker.sock"
    exit 1
fi

echo "2. Restarting Docker service"
# Restart the Docker service
sudo systemctl restart docker
if [[ $? -eq 0 ]]; then
    echo "   - Docker service restarted successfully"
else
    echo "   - Error: Failed to restart Docker service"
    exit 1
fi

echo "3. Applying Docker group changes"
# Apply Docker group changes
newgrp docker
if [[ $? -eq 0 ]]; then
    echo "   - Docker group changes applied successfully"
else
    echo "   - Warning: Failed to apply Docker group changes"
    echo "     Please log out and log back in for the changes to take effect"
fi

echo "======================================================="
echo "Docker socket and service adjustment process completed successfully!"
