#!/bin/bash

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Define the user and directory paths
CORTENSOR_DIR="$HOME/.cortensor"

echo "Starting Cortensor installation process for Cygwin on Windows..."
echo "==============================================================="
echo "1. Setting up Cortensor directory structure"

# Create the base directory for Cortensor
mkdir -p "${CORTENSOR_DIR}/bin"
mkdir -p "${CORTENSOR_DIR}/llm-files"
echo "   - Directories ~/.cortensor/bin and ~/.cortensor/llm-files created"

echo "2. Deploying the Cortensor daemon executable"

# Copy the Cortensor daemon executable to the bin directory
cp dist/cortensord.exe "${CORTENSOR_DIR}/bin"
chmod +x "${CORTENSOR_DIR}/bin/cortensord.exe"
echo "   - Cortensor daemon copied to ~/.cortensor/bin and made executable"

echo "3. Copying environment configuration file"

# Check if an existing .env file is present and back it up
if [ -f "${CORTENSOR_DIR}/.env" ]; then
    BACKUP_FILE="${CORTENSOR_DIR}/.env.bak_$(date +%Y%m%d_%H%M%S)"
    mv "${CORTENSOR_DIR}/.env" "$BACKUP_FILE"
    echo "   - Existing .env file backed up as $BACKUP_FILE"
fi

# Copy the example environment file
cp dist/.env-example "${CORTENSOR_DIR}/.env"
echo "   - Example environment file copied to ~/.cortensor/.env"

echo "4. Creating Cortensor startup and stop scripts"

# Copy the startup and stop scripts for Cortensor
cp utils/start-win-cygwin.sh "${CORTENSOR_DIR}/start-cortensor.sh"
cp utils/stop-win-cygwin.sh "${CORTENSOR_DIR}/stop-cortensor.sh"
chmod +x "${CORTENSOR_DIR}/start-cortensor.sh"
chmod +x "${CORTENSOR_DIR}/stop-cortensor.sh"
echo "   - Start script copied to ~/.cortensor/start-cortensor.sh"
echo "   - Stop script copied to ~/.cortensor/stop-cortensor.sh"

echo "==============================================================="
echo "Cortensor installation process for Cygwin completed successfully!"
echo ""
echo "To start Cortensor: ~/.cortensor/start-cortensor.sh"
echo "To stop Cortensor:  ~/.cortensor/stop-cortensor.sh"
echo "To update .env:     Edit the file ~/.cortensor/.env"
