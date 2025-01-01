#!/bin/bash

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "Starting Cortensor installation process for macOS..."
echo "========================================="

echo "1. Setting up directory structure"
# Create necessary directories
mkdir -p ~/bin
mkdir -p ~/.cortensor/logs
mkdir -p ~/bin/llm-files
echo "   - Directories ~/bin, ~/.cortensor/logs, and ~/bin/llm-files created"

echo "2. Deploying the Cortensor daemon executable"
# Copy the darwin (macOS) specific Cortensor daemon executable
cp dist/cortensord-darwin ~/bin/cortensord
chmod +x ~/bin/cortensord
echo "   - Cortensor daemon copied to ~/bin and made executable"

echo "3. Copying start and stop scripts"
cp utils/start-osx.sh ~/bin/start-cortensor.sh
cp utils/stop-osx.sh ~/bin/stop-cortensor.sh
chmod +x ~/bin/start-cortensor.sh
chmod +x ~/bin/stop-cortensor.sh
echo "   - Start and stop scripts copied from utils folder and made executable"

echo "4. Setting up LLM integration"
echo "   - Directory ~/bin/llm-files created (if not already present)"

echo "5. Copying environment configuration file"
if [ -f ~/.cortensor/.env ]; then
    BACKUP_FILE="~/.cortensor/.env.bak_$(date +%Y%m%d_%H%M%S)"
    cp ~/.cortensor/.env "$BACKUP_FILE"
    echo "   - Existing environment file backed up as $BACKUP_FILE"
fi
cp dist/.env-example ~/.cortensor/.env
echo "   - Example environment file copied to ~/.cortensor/.env"

echo "6. Creating log files"
touch ~/.cortensor/logs/cortensord.log
touch ~/.cortensor/logs/cortensord-llm.log
echo "   - Log files created in ~/.cortensor/logs/"

echo "7. Adding bin directory to PATH"
# Add ~/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bash_profile
    echo "   - Added ~/bin to PATH in shell configuration files"
fi

echo "========================================="
echo "Cortensor installation completed successfully!"
echo ""
echo "Usage:"
echo "  - To start Cortensor:  start-cortensor.sh"
echo "  - To stop Cortensor:   stop-cortensor.sh"
echo "  - Logs are available in: ~/.cortensor/logs/"
echo ""
echo "Note: You may need to restart your terminal or run 'source ~/.zshrc'"
echo "      (or ~/.bash_profile) to use the commands immediately."
