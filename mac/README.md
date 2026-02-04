# Copyparty Setup on macOS MacMini

## Installation Complete ✅

### Directory Structure
```
~/copyparty/
├── copyparty-sfx.py          # Main executable
├── copyparty.conf           # Configuration file
├── start-copyparty.sh       # Basic startup script
├── start-copyparty-complete.sh  # Complete startup script
├── com.copyparty.server.plist  # Launch service file
└── shares/                   # Share directories
    ├── public/               # Public read/write access
    ├── private/              # Admin only access
    ├── backup/               # Backup storage
    ├── media/               # Media files (public read, admin write)
    └── documents/           # Documents (admin only)
```

### Access Information

#### Network Details
- **Public IP**: 140.248.44.192
- **Tailscale IP**: 100.64.0.6
- **Local IP**: Check with `ifconfig`

#### Access URLs
- **Local**: http://localhost:3923
- **Public**: http://140.248.44.192:3923
- **Tailscale**: http://100.64.0.6:3923
- **FTP**: ftp://140.248.44.192:2121
- **SFTP**: sftp://140.248.44.192:2222
- **WebDAV**: http://140.248.44.192:8080

### Admin Credentials
- **Username**: admin
- **Password**: DSMOTIFXS678!

### Starting Copyparty

#### Method 1: Manual Start
```bash
cd ~/copyparty
./start-copyparty-complete.sh
```

#### Method 2: Install as macOS Service
```bash
cp ~/copyparty/com.copyparty.server.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.copyparty.server.plist
launchctl start com.copyparty.server
```

#### Method 3: Stop Service
```bash
launchctl stop com.copyparty.server
launchctl unload ~/Library/LaunchAgents/com.copyparty.server.plist
```

### Features Enabled

#### Core Features
- ✅ HTTP file server (port 3923)
- ✅ FTP server (port 2121)
- ✅ SFTP server (port 2222)
- ✅ WebDAV server (port 8080)
- ✅ User authentication
- ✅ Volume-based access control

#### Advanced Features
- ✅ Thumbnail generation
- ✅ File deduplication
- ✅ Search functionality
- ✅ Music library support
- ✅ Share links with permissions
- ✅ File versioning
- ✅ Resumable uploads
- ✅ Zeroconf/Bonjour discovery

#### Network Features
- ✅ Headscale/Tailscale integration
- ✅ Public IP access
- ✅ Multi-interface binding (0.0.0.0)

#### Accessibility Features (Pending)
- 🔄 accesskit.dev compliance
- 🔄 ARIA labels
- 🔄 Keyboard navigation
- 🔄 Screen reader support

### Security Notes

1. **Firewall**: Ensure ports 3923, 2121, 2222, and 8080 are open
2. **SSL/TLS**: Self-signed certificates will be generated
3. **Passwords**: Config file has restricted permissions (600)
4. **Network**: Bound to all interfaces for remote access

### Share Types

#### Public Share (/public)
- **Access**: Read/write for everyone
- **Use**: General file sharing

#### Private Share (/private)
- **Access**: Admin only
- **Use**: Sensitive files

#### Backup Share (/backup)
- **Access**: Admin read/write, authenticated users read
- **Use**: Backup storage

#### Media Share (/media)
- **Access**: Public read, admin write
- **Use**: Media files (images, videos, music)

#### Documents Share (/documents)
- **Access**: Admin only
- **Use**: Document storage

### Logging

- **Main log**: ~/copyparty/copyparty.log
- **Service stdout**: ~/copyparty/copyparty.out.log
- **Service stderr**: ~/copyparty/copyparty.err.log

### Next Steps

1. Start the server using one of the methods above
2. Test access via web browser
3. Configure firewall if needed
4. Set up additional users if required
5. Apply accessibility improvements to WebUI

### Troubleshooting

- **Port conflicts**: Check if ports are already in use
- **Permission errors**: Ensure file permissions are correct
- **Network access**: Verify firewall settings
- **Service issues**: Check log files for errors