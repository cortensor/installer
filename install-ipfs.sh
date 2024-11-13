#!/bin/bash

# This script installs IPFS.
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_linux-arm64.tar.gz
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_darwin-amd64.tar.gz

# Navigate to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the directory
cd $DIR

# Download and unpack the IPFS package
echo "Downloading IPFS..."
curl -fsSL https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz -o kubo_v0.29.0_linux-amd64.tar.gz
tar xzfv kubo_v0.29.0_linux-amd64.tar.gz

# Install IPFS
echo "Installing IPFS..."
sudo ./kubo/install.sh
