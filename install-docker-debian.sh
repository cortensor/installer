#!/bin/bash

# Cortensor Docker Debian Installer
# This script installs Docker on Debian systems for Cortensor nodes.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025
#
# https://docs.docker.com/engine/install/debian/

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR

echo "Starting Docker installation process for Debian..."
echo "==================================================="

echo "1. Updating package lists and installing prerequisites"
# Update and install required packages
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
echo "   - Package lists updated and prerequisites installed"

echo "2. Setting up Docker GPG key and repository"
# Create a directory for Docker's GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Download and add Docker's GPG key
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "   - Docker GPG key added"

# Add the Docker repository to APT sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "   - Docker repository added to APT sources"

echo "3. Installing Docker components"
# Update APT and install Docker components
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "   - Docker components installed successfully"

echo "4. Creating Docker group"
# Create the Docker group
sudo groupadd docker

echo "5. Adding user to Docker group"
# Add the current user to the Docker group
sudo usermod -aG docker $USER

echo "6. Reloading groups"
# Reload the groups to apply the changes
newgrp docker

echo "==================================================="
echo "Docker installation process completed successfully!"
