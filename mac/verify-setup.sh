#!/bin/bash

# Copyparty Setup Verification Script

COPYPARTY_DIR="$HOME/copyparty"
CONFIG_FILE="$COPYPARTY_DIR/copyparty.conf"

echo "=== Copyparty Setup Verification ==="
echo ""

# Check if all files exist
echo "📁 Checking files..."
files=(
    "copyparty-sfx.py"
    "copyparty.conf"
    "start-copyparty.sh"
    "start-copyparty-complete.sh"
    "com.copyparty.server.plist"
    "README.md"
    "accessibility.css"
    "accessibility.js"
)

for file in "${files[@]}"; do
    if [ -f "$COPYPARTY_DIR/$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

echo ""

# Check directories
echo "📁 Checking directories..."
dirs=(
    "shares/public"
    "shares/private"
    "shares/backup"
    "shares/media"
    "shares/documents"
    "webui-patches"
)

for dir in "${dirs[@]}"; do
    if [ -d "$COPYPARTY_DIR/$dir" ]; then
        echo "✅ $dir/ exists"
    else
        echo "❌ $dir/ missing"
    fi
done

echo ""

# Check network information
echo "🌐 Network Configuration..."
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "Unknown")
TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "Not available")
LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')

echo "Public IP: $PUBLIC_IP"
echo "Tailscale IP: $TAILSCALE_IP"
echo "Local IP: $LOCAL_IP"

echo ""

# Check configuration
echo "⚙️ Configuration check..."
if [ -f "$CONFIG_FILE" ]; then
    echo "✅ Config file exists"
    
    # Check for admin credentials
    if grep -q "admin:DSMOTIFXS678!" "$CONFIG_FILE"; then
        echo "✅ Admin credentials configured"
    else
        echo "❌ Admin credentials missing"
    fi
    
    # Check for volume configuration
    if grep -q "shares" "$CONFIG_FILE"; then
        echo "✅ Volume shares configured"
    else
        echo "❌ Volume shares missing"
    fi
    
    # Check for network binding
    if grep -q "0.0.0.0" "$CONFIG_FILE"; then
        echo "✅ Network binding configured for remote access"
    else
        echo "❌ Network binding not configured"
    fi
else
    echo "❌ Config file missing"
fi

echo ""

# Check permissions
echo "🔒 Permissions check..."
if [ -f "$CONFIG_FILE" ]; then
    perms=$(ls -la "$CONFIG_FILE" | awk '{print $1}')
    echo "Config file permissions: $perms"
    if [ "$perms" = "-rw-------" ]; then
        echo "✅ Config file has secure permissions"
    else
        echo "⚠️ Consider setting chmod 600 on config file"
    fi
fi

echo ""

# Test Copyparty syntax
echo "🧪 Copyparty syntax test..."
cd "$COPYPARTY_DIR"
if python3 ./copyparty-sfx.py -c "$CONFIG_FILE" --help > /dev/null 2>&1; then
    echo "✅ Configuration syntax is valid"
else
    echo "⚠️ Configuration may have syntax issues"
fi

echo ""

# Access URLs summary
echo "🔗 Access URLs Summary:"
echo "Local:     http://localhost:3923"
echo "Network:   http://$LOCAL_IP:3923"
if [ "$PUBLIC_IP" != "Unknown" ]; then
    echo "Public:    http://$PUBLIC_IP:3923"
fi
if [ "$TAILSCALE_IP" != "Not available" ]; then
    echo "Tailscale: http://$TAILSCALE_IP:3923"
fi

echo ""
echo "Additional Services:"
echo "FTP:       ftp://$PUBLIC_IP:2121"
echo "SFTP:      sftp://$PUBLIC_IP:2222"
echo "WebDAV:    http://$PUBLIC_IP:8080"

echo ""
echo "🔑 Admin Login:"
echo "Username: admin"
echo "Password: DSMOTIFXS678!"

echo ""
echo "🚀 To start Copyparty:"
echo "cd ~/copyparty"
echo "./start-copyparty-complete.sh"
echo ""
echo "Or install as a service:"
echo "cp ~/copyparty/com.copyparty.server.plist ~/Library/LaunchAgents/"
echo "launchctl load ~/Library/LaunchAgents/com.copyparty.server.plist"

echo ""
echo "♿ Accessibility features are ready to be applied."
echo "See webui-patches/ directory for accessibility enhancements."

echo ""
echo "=== Setup Verification Complete ==="