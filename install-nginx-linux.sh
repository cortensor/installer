#!/bin/bash

# Cortensor Router Node Nginx Installer
# This script installs and configures Nginx for the Cortensor Router Node
# Copyright (c) 2024-2025 Cortensor Network. All rights reserved.
# Copyright (c) 2024-2025 Eliza Labs Inc. All rights reserved.
#
# Version: 0.0.1
# Last updated: May 31, 2025

# Navigate to the directory where the script resides
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR

echo "Starting Nginx installation and configuration process..."
echo "========================================================"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root or with sudo privileges"
        exit 1
    fi
}

# Check if running as root
check_root

echo "1. Installing Nginx"
if command_exists apt-get; then
    # Debian/Ubuntu
    apt-get update
    apt-get install -y nginx certbot python3-certbot-nginx
elif command_exists yum; then
    # CentOS/RHEL
    yum install -y epel-release
    yum install -y nginx certbot python3-certbot-nginx
else
    echo "   - Error: Unsupported package manager. Please install Nginx manually."
    exit 1
fi

if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to install Nginx"
    exit 1
fi
echo "   - Nginx installed successfully"

echo "2. Configuring Nginx for Router Node"
# Create Nginx configuration directory if it doesn't exist
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

# Copy the router-node.nginx configuration file
cp "$DIR/conf/router-node.nginx" /etc/nginx/sites-available/router-node.conf
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to copy router-node configuration"
    exit 1
fi

# Create a symbolic link to enable the site
ln -sf /etc/nginx/sites-available/router-node.conf /etc/nginx/sites-enabled/

# Create CORS config snippet for reuse
cat > /etc/nginx/cors_config.conf << 'EOF'
# CORS configuration for Cortensor Router Node
if ($request_method = 'OPTIONS') {
    add_header 'Access-Control-Allow-Origin' $cors_allowed_origin;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type, X-API-Key';
    add_header 'Access-Control-Max-Age' 1728000;
    add_header 'Content-Type' 'text/plain charset=UTF-8';
    add_header 'Content-Length' 0;
    return 204;
}

# Restricted CORS (specific origins)
add_header 'Access-Control-Allow-Origin' $cors_allowed_origin always;
add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type, X-API-Key' always;
EOF

echo "   - Router Node Nginx configuration installed"

echo "3. Testing Nginx configuration"
nginx -t
if [[ $? -ne 0 ]]; then
    echo "   - Error: Nginx configuration test failed"
    echo "   - Please check the configuration file for errors"
    exit 1
fi
echo "   - Nginx configuration test passed"

echo "4. Restarting Nginx service"
systemctl restart nginx
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to restart Nginx"
    exit 1
fi
echo "   - Nginx service restarted successfully"

echo "5. Setting up SSL with Certbot"
echo "   - Note: You will need to configure your domain DNS before running this step"
echo "   - To set up SSL later, run: sudo certbot --nginx -d your-domain.com"

# Ask if the user wants to set up SSL now
read -p "Do you want to set up SSL now? (y/n): " setup_ssl
if [[ "$setup_ssl" == "y" || "$setup_ssl" == "Y" ]]; then
    read -p "Enter your domain name (e.g., router-dev-0.cortensor.network): " domain_name
    if [[ -z "$domain_name" ]]; then
        echo "   - No domain provided, skipping SSL setup"
    else
        certbot --nginx -d "$domain_name"
        if [[ $? -ne 0 ]]; then
            echo "   - Error: SSL setup failed"
            echo "   - You can try again later with: sudo certbot --nginx -d $domain_name"
        else
            echo "   - SSL setup completed successfully"
        fi
    fi
else
    echo "   - SSL setup skipped"
fi

echo "========================================================"
echo "Nginx installation and configuration process completed!"
echo "The Router Node Nginx configuration is now installed."
echo ""
echo "Next steps:"
echo "1. Make sure your API server is running on port 5010"
echo "2. If you skipped SSL setup, run: sudo certbot --nginx -d your-domain.com"
echo "3. To customize allowed domains for CORS, edit /etc/nginx/sites-available/router-node.conf"
echo ""
echo "To check Nginx status: sudo systemctl status nginx"
echo "To restart Nginx: sudo systemctl restart nginx"
echo "========================================================"
