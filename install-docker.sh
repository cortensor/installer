#!/bin/bash

# This script installs Docker on Ubuntu systems.
# https://docs.docker.com/engine/install/ubuntu/

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Update and install required packages
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y

# Create a directory for Docker's GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Download and add Docker's GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to APT sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update APT and install Docker components
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
