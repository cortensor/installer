#!/bin/bash

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR

# Define the user under which the Cortensor services will run
CORTENSOR_USER=deploy

echo "Starting Cortensor installation process..."
echo "========================================="
echo "1. Adding system user for Cortensor services"

# Add a new system user for running the Cortensor services
sudo adduser $CORTENSOR_USER
echo "   - User $CORTENSOR_USER added successfully"

echo "2. Granting necessary permissions to the user"

# Add the new user to the sudo group to grant administrative privileges
sudo usermod -aG sudo $CORTENSOR_USER
echo "   - $CORTENSOR_USER added to sudo group"

# Add the new user to the docker group to allow Docker command execution
sudo usermod -aG docker $CORTENSOR_USER
# sudo chown root:docker /var/run/docker.sock
newgrp docker
echo "   - $CORTENSOR_USER added to docker group"

echo "3. Deploying the Cortensor daemon executable"

# Copy the Cortensor daemon executable to a system-wide location
sudo cp dist/cortensord /usr/local/bin
sudo chmod +x /usr/local/bin/cortensord
echo "   - Cortensor daemon copied to /usr/local/bin and made executable"

echo "4. Setting up directories and files for LLM integration"

# Create a directory for LLM files, if needed
sudo mkdir -p /usr/local/bin/llm-files
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} /usr/local/bin/llm-files
echo "   - Directory /usr/local/bin/llm-files created and ownership assigned to $CORTENSOR_USER"

echo "5. Configuring Cortensor systemd service"

# Copy the Cortensor systemd service file to the systemd system directory
sudo cp dist/cortensord.service /etc/systemd/system
echo "   - cortensord.service file copied to /etc/systemd/system"

echo "6. Creating configuration directory for Cortensor"

# Create the configuration directory for Cortensor under the user's home directory
sudo -u ${CORTENSOR_USER} mkdir -p /home/${CORTENSOR_USER}/.cortensor
echo "   - Configuration directory /home/${CORTENSOR_USER}/.cortensor created"

echo "7. Copying environment configuration file"

# Copy the example environment file to the configuration directory
sudo -u ${CORTENSOR_USER} cp dist/.env-example /home/${CORTENSOR_USER}/.cortensor/.env
echo "   - Example environment file copied to /home/${CORTENSOR_USER}/.cortensor/.env"

echo "8. Setting up log files"

# Create log files for the Cortensor daemon and set appropriate permissions
sudo touch /var/log/cortensord.log
sudo touch /var/log/cortensord-llm.log
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} /var/log/cortensord.log
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} /var/log/cortensord-llm.log
echo "   - Log files /var/log/cortensord.log and /var/log/cortensord-llm.log created with correct permissions"

echo "9. Enabling Cortensor daemon service"

# Reload systemd to read new service files and enable Cortensor to start at boot
sudo systemctl daemon-reload
sudo systemctl enable cortensord
echo "   - Systemd reloaded and cortensord service enabled to start at boot"

echo "========================================="
echo "Cortensor installation process completed successfully!"
