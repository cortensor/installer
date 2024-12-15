#!/bin/bash

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR

# Define the user under which the Cortensor services will run
CORTENSOR_DIR="$HOME/.cortensor"

echo "Starting Cortensor installation process for Cygwin on Windows..."
echo "==============================================================="
echo "1. Setting up Cortensor directory structure"

# Create the base directory for Cortensor
mkdir -p ${CORTENSOR_DIR}/bin
mkdir -p ${CORTENSOR_DIR}/llm-files
echo "   - Directories ~/.cortensor/bin and ~/.cortensor/llm-files created"

echo "2. Deploying the Cortensor daemon executable"

# Copy the Cortensor daemon executable to the bin directory
cp dist/cortensord.exe ${CORTENSOR_DIR}/bin
chmod +x ${CORTENSOR_DIR}/bin/cortensord.exe
echo "   - Cortensor daemon copied to ~/.cortensor/bin and made executable"

echo "3. Copying environment configuration file"

# Create configuration directory
# mkdir -p ${CORTENSOR_DIR}/.config

# Copy the example environment file
cp dist/.env-example ${CORTENSOR_DIR}/.env
echo "   - Example environment file copied to ~/.cortensor/.env"

echo "4. Creating Cortensor startup script"

# Create a startup script for manually starting Cortensor
START_SCRIPT="${CORTENSOR_DIR}/start-cortensor.sh"
cat <<EOL > $START_SCRIPT
#!/bin/bash
export PATH=\$HOME/.cortensor/bin:\$HOME/.cortensor/llm-files:\$PATH
cortensord.exe \$HOME/.cortensor/.env minerv1
EOL

chmod +x $START_SCRIPT
echo "   - Start script created at ~/.cortensor/start-cortensor.sh"

echo "==============================================================="
echo "Cortensor installation process for Cygwin completed successfully!"
echo "To start Cortensor, run: ~/.cortensor/start-cortensor.sh"
