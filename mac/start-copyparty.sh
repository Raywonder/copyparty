#!/bin/bash

# Copyparty Startup Script
# This script starts Copyparty with all features enabled

COPYPARTY_DIR="$HOME/copyparty"
CONFIG_FILE="$COPYPARTY_DIR/copyparty.conf"
LOG_FILE="$COPYPARTY_DIR/copyparty.log"

echo "Starting Copyparty with all features..."
echo "Directory: $COPYPARTY_DIR"
echo "Config: $CONFIG_FILE"
echo "Log: $LOG_FILE"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Change to copyparty directory
cd "$COPYPARTY_DIR"

# Start Copyparty with the configuration file
python3 ./copyparty-sfx.py -c "$CONFIG_FILE" 2>&1 | tee "$LOG_FILE"