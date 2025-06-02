#!/bin/bash

# Cortensor IPFS macOS Installer
# This script installs IPFS for Cortensor nodes on macOS systems.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025
#
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_darwin-amd64.tar.gz

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "Starting IPFS installation process..."
echo "======================================="

# Define variables
IPFS_VERSION="v0.33.0"
IPFS_PACKAGE="kubo_${IPFS_VERSION}_darwin-amd64.tar.gz"
IPFS_URL="https://github.com/ipfs/kubo/releases/download/${IPFS_VERSION}/${IPFS_PACKAGE}"
INSTALL_DIR="$HOME/.cortensor/bin"

echo "1. Downloading IPFS package - Darwin AMD64"
# Download the IPFS package
curl -fsSL "$IPFS_URL" -o "$IPFS_PACKAGE"
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to download IPFS package from $IPFS_URL"
    exit 1
fi
echo "   - IPFS package downloaded successfully"

echo "2. Extracting IPFS package"
# Extract the package
tar xzfv "$IPFS_PACKAGE"
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

echo "4. Adding IPFS to PATH"
# Add ~/.cortensor/bin to PATH if not already present
if [[ ":$PATH:" != *":$HOME/.cortensor/bin:"* ]]; then
    echo 'export PATH="$HOME/.cortensor/bin:$PATH"' >> ~/.zshrc
    echo 'export PATH="$HOME/.cortensor/bin:$PATH"' >> ~/.bash_profile
    echo "   - Added ~/.cortensor/bin to PATH in shell configuration files"
fi

echo "5. Cleaning up"
# Remove the downloaded package and extracted files
rm -rf "$IPFS_PACKAGE" kubo
echo "   - Cleaned up installation files"

echo "======================================="
echo "IPFS installation process completed successfully!"
echo ""
echo "To verify IPFS installation, run: ipfs --version"
