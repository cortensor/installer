#!/bin/bash

# Cortensor IPFS Windows Installer (Cygwin)
# This script installs IPFS for Cortensor nodes on Windows systems using Cygwin.
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025
#
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_linux-arm64.tar.gz
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_darwin-amd64.tar.gz
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_windows-amd64.zip

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORTENSOR_DIR="$HOME/.cortensor"

cd $DIR

echo "Starting IPFS installation process..."
echo "======================================="

echo "1. Downloading IPFS package - Windows AMD64 (Cygwin)"
# Download the IPFS package
IPFS_VERSION="v0.33.0"
IPFS_PACKAGE="kubo_${IPFS_VERSION}_windows-amd64.zip"
IPFS_URL="https://github.com/ipfs/kubo/releases/download/${IPFS_VERSION}/${IPFS_PACKAGE}"

curl -fsSL $IPFS_URL -o $IPFS_PACKAGE
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to download IPFS package from $IPFS_URL"
    exit 1
fi
echo "   - IPFS package downloaded successfully"

echo "2. Extracting IPFS package"
# Extract the package
unzip $IPFS_PACKAGE
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to extract $IPFS_PACKAGE"
    exit 1
fi
echo "   - IPFS package extracted successfully"

echo "3. Installing IPFS"
# Run the installation script
mkdir -p ~/.cortensor/bin
cp -f ./kubo/ipfs.exe ~/.cortensor/bin/
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to install IPFS"
    exit 1
fi
echo "   - IPFS installed successfully"

echo "======================================="
echo "IPFS installation process completed successfully!"

mkdir -p "${CORTENSOR_DIR}/logs"
echo "   - Created logs directory: ${CORTENSOR_DIR}/logs"
touch "${CORTENSOR_DIR}/logs/cortensord.log"
echo "   - Created log file: ${CORTENSOR_DIR}/logs/cortensord.log"
touch "${CORTENSOR_DIR}/logs/cortensord-llm.log"
echo "   - Created log file: ${CORTENSOR_DIR}/logs/cortensord-llm.log"
