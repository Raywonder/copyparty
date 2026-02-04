#!/bin/bash

# Copyparty Complete Startup Script
# This script starts Copyparty with all features enabled

COPYPARTY_DIR="$HOME/copyparty"
CONFIG_FILE="$COPYPARTY_DIR/copyparty.conf"
LOG_FILE="$COPYPARTY_DIR/copyparty.log"

echo "=== Copyparty Complete Setup ==="
echo "Directory: $COPYPARTY_DIR"
echo "Config: $CONFIG_FILE"
echo "Log: $LOG_FILE"
echo ""

# Network Information
echo "=== Network Access Information ==="
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "Unknown")
TAILSCALE_IP=$(/Applications/Tailscale.app/Contents/MacOS/Tailscale ip -4 2>/dev/null || echo "Not available")
LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')

echo "Public IP: $PUBLIC_IP"
echo "Tailscale IP: $TAILSCALE_IP"
echo "Local IP: $LOCAL_IP"
echo ""

echo "=== Access URLs ==="
echo "Local access: http://localhost:3923"
echo "Network access: http://$LOCAL_IP:3923"
if [ "$PUBLIC_IP" != "Unknown" ]; then
    echo "Public access: http://$PUBLIC_IP:3923"
fi
if [ "$TAILSCALE_IP" != "Not available" ]; then
    echo "Tailscale access: http://$TAILSCALE_IP:3923"
fi
echo ""

echo "=== Available Shares ==="
echo "📁 File Shares:"
echo "  /public     - Public read/write access"
echo "  /private    - Admin only access"
echo "  /backup     - Admin read/write, users read"
echo "  /media      - Public read, admin write"
echo "  /documents  - Admin only access"
echo ""
echo "👨‍💻 Development Shares:"
echo "  /dev        - Main development folder (read/write)"
echo "  /dev-apps   - Applications development"
echo "  /dev-docs   - Documentation projects"
echo "  /dev-mcp    - MCP servers and configs"
echo "  /dev-unsorted - Unsorted development files"
echo "  /dev-whmcs  - WHMCS modules development"
echo ""

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Change to copyparty directory
cd "$COPYPARTY_DIR"

# Start Copyparty with basic config first, then add features
echo "Starting Copyparty with all features..."
python3 ./copyparty-sfx.py \
    -c "$CONFIG_FILE" \
    -e2d \
    -e2t \
    --ftp 3921 \
    --sftp 3922 \
    --sftp-pw \
    --log-htp \
    --log-thrs 10 \
    --log-conn \
    2>&1 | tee "$LOG_FILE"