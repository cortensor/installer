#!/bin/bash

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR

# Define the user under which the Cortensor services will run
CORTENSOR_USER=deploy

# Add a new system user for running the Cortensor services
sudo adduser $CORTENSOR_USER
echo "Added user $CORTENSOR_USER"

# Add the new user to the sudo group to grant administrative privileges
sudo usermod -aG sudo $CORTENSOR_USER
echo "Added ${CORTENSOR_USER} to sudo group"

# Add the new user to the docker group to allow Docker command execution
sudo usermod -aG docker $CORTENSOR_USER
echo "Added $CORTENSOR_USER to docker group"

# Copy the Cortensor daemon executable to a system-wide location
sudo cp dist/cortensord /usr/local/bin
sudo chmod +x /usr/local/bin/cortensord
echo "Copied cortensord to /usr/local/bin"

# Create a directory for LLM files, if needed
sudo mkdir -p /usr/local/bin/llm-files
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} /usr/local/bin/llm-files
echo "Created directory /usr/local/bin/llm-files"

# Copy the Cortensor systemd service file to the systemd system directory
sudo cp dist/cortensord.service /etc/systemd/system
echo "Copied cortensord.service to /etc/systemd/system"

# Create the configuration directory for Cortensor under the user's home directory
sudo -u ${CORTENSOR_USER} mkdir -p /home/${CORTENSOR_USER}/.cortensor
echo "Created directory /home/${CORTENSOR_USER}/.cortensor"

# Copy the example environment file to the configuration directory
sudo -u ${CORTENSOR_USER} cp dist/.env-example /home/${CORTENSOR_USER}/.cortensor/.env
echo "Copied .env to /home/${CORTENSOR_USER}/.cortensor"

# Create log files for the Cortensor daemon and set appropriate permissions
sudo touch /var/log/cortensord.log
sudo touch /var/log/cortensord-llm.log
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} /var/log/cortensord.log
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} /var/log/cortensord-llm.log
echo "Created and set permissions for log files /var/log/cortensord.log and /var/log/cortensord-llm.log"

# Reload systemd to read new service files and enable Cortensor to start at boot
sudo systemctl daemon-reload
sudo systemctl enable cortensord
echo "Cortensor daemon installed and set to start on system boot"

