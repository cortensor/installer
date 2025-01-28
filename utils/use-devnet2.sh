#!/bin/bash

# This script updates the CONTRACT_ADDRESS_RUNTIME in the .env file.
# Note: This script is specifically for DevNet #2.

# Define the path to the .env file
ENV_FILE="$HOME/.cortensor/.env"

# New contract address for DevNet #2
NEW_ADDRESS="0xC0e4E569810a445d097CBB20e25775701f41A8cc"

# Check if the .env file exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: .env file not found at $ENV_FILE."
    exit 1
fi

# Validate the address format (basic check for 0x-prefixed and 42 characters long)
if [[ ! $NEW_ADDRESS =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    echo "Error: Invalid Ethereum address format. Please provide a valid address."
    exit 1
fi

# Use sed to update the line in the .env file
if sed -i.bak -E "s/^CONTRACT_ADDRESS_RUNTIME=\"0x[a-fA-F0-9]{40}\"/CONTRACT_ADDRESS_RUNTIME=\"$NEW_ADDRESS\"/" "$ENV_FILE"; then
    echo "CONTRACT_ADDRESS_RUNTIME updated successfully in $ENV_FILE for DevNet #2."
else
    echo "Error: Failed to update the .env file."
    exit 1
fi

# Optionally display the updated line for confirmation
UPDATED_LINE=$(grep "^CONTRACT_ADDRESS_RUNTIME=" "$ENV_FILE")
echo "Updated line: $UPDATED_LINE (DevNet #2)"
