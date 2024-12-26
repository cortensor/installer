#!/bin/bash

# This script restores the .env file from a specified backup and backs up the current .env file.

# Navigate to the Cortensor configuration directory
CORTENSOR_DIR="$HOME/.cortensor"
ENV_FILE="$CORTENSOR_DIR/.env"
BACKUP_DIR="$CORTENSOR_DIR/backups"

# Ensure the configuration directory exists
if [ ! -d "$CORTENSOR_DIR" ]; then
    echo "Cortensor directory ($CORTENSOR_DIR) not found. Exiting."
    exit 1
fi

# Ensure the backups directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backups directory ($BACKUP_DIR) not found. Exiting."
    exit 1
fi

# Check if the user provided a backup file name
if [ -z "$1" ]; then
    echo "Usage: $0 <backup_file_name>"
    echo "Example: $0 .env_backup_20241223_140500"
    exit 1
fi

BACKUP_FILE="$BACKUP_DIR/$1"

# Ensure the specified backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file $BACKUP_FILE not found. Exiting."
    exit 1
fi

# Backup the current .env file
if [ -f "$ENV_FILE" ]; then
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    CURRENT_BACKUP_FILE="$BACKUP_DIR/.env_backup_$TIMESTAMP"
    echo "Backing up current .env file to $CURRENT_BACKUP_FILE..."
    cp "$ENV_FILE" "$CURRENT_BACKUP_FILE"

    if [ $? -eq 0 ]; then
        echo "Current .env file backed up successfully."
    else
        echo "Failed to back up current .env file. Exiting."
        exit 1
    fi
else
    echo "No existing .env file to back up."
fi

# Restore the specified backup
echo "Restoring backup $BACKUP_FILE to $ENV_FILE..."
cp "$BACKUP_FILE" "$ENV_FILE"

# Check if the restore operation was successful
if [ $? -eq 0 ]; then
    echo "Backup $BACKUP_FILE restored successfully."
else
    echo "Failed to restore backup. Exiting."
    exit 1
fi
