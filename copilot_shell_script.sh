#!/bin/bash

set -euo pipefail

CONFIG_FILE="config/config.env"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

read -p "Enter the new assignment name: " NEW_ASSIGN
if [[ -z "$NEW_ASSIGN" ]]; then
    echo "Assignment name cannot be empty. Exiting."
    exit 1
fi

# Use a backup in case something goes wrong
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# sed replacement ensures only the ASSIGNMENT line is changed
sed -i "s|^ASSIGNMENT=.*|ASSIGNMENT=\"$NEW_ASSIGN\"|" "$CONFIG_FILE"

echo "Assignment updated successfully in $CONFIG_FILE"

if [[ -x "startup.sh" ]]; then
    echo
    echo "Running submission check for the new assignment..."
    ./startup.sh
else
    echo "Warning: startup.sh not found or not executable. Run it manually to check submissions."
fi
