#!/bin/bash

# Cortensor Node Linux Installer
# This script installs and configures Cortensor node components on Linux systems.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR

# Define the user under which the Cortensor services will run
CORTENSOR_USER=deploy
CORTENSOR_HOME="/home/${CORTENSOR_USER}/.cortensor"
CORTENSOR_BIN="${CORTENSOR_HOME}/bin"
CORTENSOR_LOGS="${CORTENSOR_HOME}/logs"

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
echo "   - $CORTENSOR_USER added to docker group"

echo "3. Deploying the Cortensor daemon executable"

# Copy the Cortensor daemon executable to the user's bin directory
sudo -u ${CORTENSOR_USER} mkdir -p ${CORTENSOR_BIN}
sudo cp dist/cortensord /usr/local/bin/cortensord
sudo chmod +x /usr/local/bin/cortensord
sudo ln -sfn /usr/local/bin/cortensord ${CORTENSOR_BIN}/cortensord
echo "   - Cortensor daemon copied to ${CORTENSOR_BIN} and made executable"

echo "4. Setting up directories and files for LLM integration"

# Create a directory for LLM files, if needed
sudo mkdir -p ${CORTENSOR_HOME}/llm-files
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} ${CORTENSOR_HOME}/llm-files
echo "   - Directory ${CORTENSOR_HOME}/llm-files created and ownership assigned to $CORTENSOR_USER"

echo "5. Copying start and stop scripts"

# Copy the start and stop scripts to the user's Cortensor bin directory
sudo cp utils/start-linux.sh ${CORTENSOR_BIN}/start-cortensor.sh
sudo cp utils/stop-linux.sh ${CORTENSOR_BIN}/stop-cortensor.sh
sudo chmod +x ${CORTENSOR_BIN}/start-cortensor.sh
sudo chmod +x ${CORTENSOR_BIN}/stop-cortensor.sh
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} ${CORTENSOR_BIN}/start-cortensor.sh
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} ${CORTENSOR_BIN}/stop-cortensor.sh
echo "   - Start and stop scripts copied to ${CORTENSOR_BIN} and made executable"

echo "6. Configuring Cortensor systemd service"

# Copy the Cortensor systemd service file to the systemd system directory
sudo cp dist/cortensor.service /etc/systemd/system
echo "   - cortensor.service file copied to /etc/systemd/system"

echo "7. Creating configuration directory for Cortensor"

# Create the configuration directory for Cortensor under the user's home directory
sudo -u ${CORTENSOR_USER} mkdir -p ${CORTENSOR_HOME}
echo "   - Configuration directory ${CORTENSOR_HOME} created"

echo "8. Copying environment configuration file"

# Copy the example environment file to the configuration directory
sudo -u ${CORTENSOR_USER} cp dist/.env-example ${CORTENSOR_HOME}/.env
echo "   - Example environment file copied to ${CORTENSOR_HOME}/.env"

echo "9. Setting up log files"

# Create log files for the Cortensor daemon and set appropriate permissions
sudo mkdir -p ${CORTENSOR_LOGS}
sudo touch ${CORTENSOR_LOGS}/cortensord.log
sudo touch ${CORTENSOR_LOGS}/cortensord-llm.log
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} ${CORTENSOR_LOGS}/cortensord.log
sudo chown ${CORTENSOR_USER}:${CORTENSOR_USER} ${CORTENSOR_LOGS}/cortensord-llm.log
echo "   - Log files created in ${CORTENSOR_LOGS} with correct permissions"

echo "10. Enabling Cortensor daemon service"

# Reload systemd to read new service files and enable Cortensor to start at boot
sudo systemctl daemon-reload
sudo systemctl enable cortensor
echo "   - Systemd reloaded and cortensor service enabled to start at boot"

echo "========================================="
echo "Cortensor installation completed successfully!"
echo ""
echo "Recommended Usage:"
echo "  - To start Cortensor:  sudo systemctl start cortensor"
echo "  - To stop Cortensor:   sudo systemctl stop cortensor"
echo ""
echo "Manual Usage (not recommended):"
echo "  - To start Cortensor manually:  ${CORTENSOR_BIN}/start-cortensor.sh"
echo "  - To stop Cortensor manually:   ${CORTENSOR_BIN}/stop-cortensor.sh"
echo ""
echo "Logs are available in: ${CORTENSOR_LOGS}/"
echo "  - /var/log/cortensor/cortensord.log"
echo ""
echo "Note: Using systemctl is the recommended approach for managing the Cortensor service."
echo "      You may need to restart your terminal or update the PATH variable to include:"
echo "      ${CORTENSOR_BIN}"
