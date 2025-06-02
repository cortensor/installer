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

# Prompt for domain name
echo "   - Please enter your router node domain name (e.g., router.example.com):"
read -p "     Domain: " ROUTER_DOMAIN

# Use a default domain if none provided
if [[ -z "$ROUTER_DOMAIN" ]]; then
    ROUTER_DOMAIN="router.cortensor.network"
    echo "   - No domain provided, using default: $ROUTER_DOMAIN"
fi

# Use the template file and replace the domain placeholder
if [ ! -f "$DIR/conf/router-node.nginx.template" ]; then
    echo "   - Error: Template file not found at $DIR/conf/router-node.nginx.template"
    exit 1
fi

# Create the configuration file from the template with the domain replaced
cat "$DIR/conf/router-node.nginx.template" | sed "s/ROUTER_DOMAIN_PLACEHOLDER/$ROUTER_DOMAIN/g" > /etc/nginx/sites-available/router-node.conf
if [[ $? -ne 0 ]]; then
    echo "   - Error: Failed to create router-node configuration from template"
    exit 1
fi

echo "   - Router domain set to: $ROUTER_DOMAIN"
echo "   - Router Node Nginx configuration created from template"

# Create a symbolic link to enable the site
ln -sf /etc/nginx/sites-available/router-node.conf /etc/nginx/sites-enabled/

# Comment out for now since it is already contained on router-node.nginx
# Create CORS config snippet for reuse
#cat > /etc/nginx/cors_config.conf << 'EOF'
# CORS configuration for Cortensor Router Node
#if ($request_method = 'OPTIONS') {
#    add_header 'Access-Control-Allow-Origin' $cors_allowed_origin;
#    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
#    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type, X-API-Key';
#    add_header 'Access-Control-Max-Age' 1728000;
#    add_header 'Content-Type' 'text/plain charset=UTF-8';
#    add_header 'Content-Length' 0;
#    return 204;
#}

# Restricted CORS (specific origins)
#add_header 'Access-Control-Allow-Origin' $cors_allowed_origin always;
#add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
#add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type, X-API-Key' always;
#EOF

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
echo "   - To set up SSL later, run: sudo certbot --nginx -d $ROUTER_DOMAIN"

# Ask if the user wants to set up SSL now
read -p "Do you want to set up SSL now for domain '$ROUTER_DOMAIN'? (y/n): " setup_ssl
if [[ "$setup_ssl" == "y" || "$setup_ssl" == "Y" ]]; then
    # Use the domain we already collected
    echo "   - Setting up SSL for domain: $ROUTER_DOMAIN"
    certbot --nginx -d "$ROUTER_DOMAIN"
    if [[ $? -ne 0 ]]; then
        echo "   - Error: SSL setup failed"
        echo "   - You can try again later with: sudo certbot --nginx -d $ROUTER_DOMAIN"
    else
        echo "   - SSL setup completed successfully for $ROUTER_DOMAIN"
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
