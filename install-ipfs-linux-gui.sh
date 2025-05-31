#!/bin/bash

# Cortensor IPFS Linux Installer for Cortensor Desktop App
# This script installs IPFS for Cortensor nodes on Linux systems.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025
#
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_linux-arm64.tar.gz
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_darwin-amd64.tar.gz

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR

echo "Starting IPFS installation process..."
echo "======================================="

echo "1. Downloading IPFS package - Linux AMD64"
# Download the IPFS package
IPFS_VERSION="v0.33.0"
IPFS_PACKAGE="kubo_${IPFS_VERSION}_linux-amd64.tar.gz"
IPFS_URL="https://github.com/ipfs/kubo/releases/download/${IPFS_VERSION}/${IPFS_PACKAGE}"
INSTALL_DIR="$HOME/.cortensor/bin"

curl -fsSL $IPFS_URL -o $IPFS_PACKAGE
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to download IPFS package from $IPFS_URL"
    exit 1
fi
echo "   - IPFS package downloaded successfully"

echo "2. Extracting IPFS package"
# Extract the package
tar xzfv $IPFS_PACKAGE
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to extract $IPFS_PACKAGE"
    exit 1
fi
echo "   - IPFS package extracted successfully"

echo "3. Installing IPFS"
# Ensure the installation directory exists
mkdir -p "$INSTALL_DIR"
# Copy the IPFS binary to the installation directory
cp -Rfv ./kubo/ipfs "$INSTALL_DIR/"
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to install IPFS"
    exit 1
fi
chmod +x "$INSTALL_DIR/ipfs"
echo "   - IPFS installed successfully to $INSTALL_DIR"

echo "======================================="
echo "IPFS installation process completed successfully!"
