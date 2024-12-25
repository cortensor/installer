#!/bin/bash

# This script creates a backup of the Cortensor .env file.

# Navigate to the Cortensor configuration directory
CORTENSOR_DIR="$HOME/.cortensor"
ENV_FILE="$CORTENSOR_DIR/.env"
BACKUP_DIR="$CORTENSOR_DIR/backups"

# Ensure the configuration directory exists
if [ ! -d "$CORTENSOR_DIR" ]; then
    echo "Cortensor directory ($CORTENSOR_DIR) not found. Exiting."
    exit 1
fi

# Ensure the .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "No .env file found at $ENV_FILE. Exiting."
    exit 1
fi

# Create a backups directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creating backup directory at $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create backup directory. Exiting."
        exit 1
    fi
fi

# Generate a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/.env_backup_$TIMESTAMP"

# Backup the .env file
echo "Backing up .env file to $BACKUP_FILE..."
cp "$ENV_FILE" "$BACKUP_FILE"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup created successfully at $BACKUP_FILE."
else
    echo "Failed to create backup. Exiting."
    exit 1
fi
