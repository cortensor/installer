#!/bin/bash

# This script installs IPFS for Windows (Cygwin environment).
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_linux-arm64.tar.gz
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_darwin-amd64.tar.gz
# https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_windows-amd64.zip

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR

echo "Starting IPFS installation process..."
echo "======================================="

echo "1. Downloading IPFS package - Windows AMD64 (Cygwin)"
# Download the IPFS package
IPFS_VERSION="v0.29.0"
IPFS_PACKAGE="kubo_${IPFS_VERSION}_windows-amd64.zip"
IPFS_URL="https://github.com/ipfs/kubo/releases/download/${IPFS_VERSION}/${IPFS_PACKAGE}"

curl -fsSL $IPFS_URL -o $IPFS_PACKAGE
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to download IPFS package from $IPFS_URL"
    exit 1
fi
echo "   - IPFS package downloaded successfully"

echo "2. Checking for unzip tool"
# Check if unzip is installed; install if not
if ! command -v unzip &> /dev/null; then
    echo "   - unzip not found, installing unzip..."
    apt-get update && apt-get install unzip -y
    if [[ $? -ne 0 ]]; then
        echo "   - Error: Failed to install unzip"
        exit 1
    fi
    echo "   - unzip installed successfully"
else
    echo "   - unzip is already installed"
fi

echo "3. Extracting IPFS package"
# Extract the package
unzip $IPFS_PACKAGE
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to extract $IPFS_PACKAGE"
    exit 1
fi
echo "   - IPFS package extracted successfully"

echo "4. Installing IPFS"
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
