# How to Add Folders in Copyparty Web UI

## Method 1: Using the Admin Interface

1. **Access the Web UI**
   - Open your browser and go to http://localhost:3923 (or your preferred access URL)
   - Login with admin credentials:
     - Username: `admin`
     - Password: `DSMOTIFXS678!`

2. **Navigate to Admin Panel**
   - Look for the "Admin", "Settings", or "⚙️" icon in the top navigation
   - Click on it to access the administrative interface

3. **Add New Volume/Folder**
   - In the admin panel, find "Volumes", "Shares", or "Mount Points" section
   - Click "Add Volume", "New Share", or similar button
   - Fill in the required fields:
     - **Source Path**: The actual local path (e.g., `/Users/admin/dev/new-project`)
     - **Mount Point**: The URL path (e.g., `/new-project`)
     - **Permissions**: Choose from:
       - `r` - Read only
       - `w` - Write
       - `rw` - Read and write
       - `a` - Admin access
       - `e` - Execute
       - `d` - Delete
     - **Access Control**: Which users can access this folder

## Method 2: Using the Configuration File

1. **Edit the Configuration**
   ```bash
   cd ~/copyparty
   nano copyparty.conf
   ```

2. **Add New Volume Line**
   ```
   -v /path/to/folder:/url-path:permissions
   ```

   Examples:
   ```
   -v /Users/admin/Downloads:/downloads:rw
   -v /Users/admin/projects:/projects:rw
   -v /Users/admin/temp:/temp:r
   ```

3. **Restart Copyparty**
   ```bash
   # If running as service
   launchctl stop com.copyparty.server
   launchctl start com.copyparty.server
   
   # Or if running manually
   # Stop current process and restart
   ./start-copyparty-complete.sh
   ```

## Method 3: Using Command Line Arguments

You can add volumes temporarily without editing the config file:

```bash
cd ~/copyparty
python3 ./copyparty-sfx.py \
  -c copyparty.conf \
  -v /Users/admin/new-folder:/new-folder:rw \
  --host 0.0.0.0 \
  --port 3923
```

## Permission Flags Explained

| Flag | Description | Use Case |
|------|-------------|----------|
| `r`  | Read access | Public folders, documentation |
| `w`  | Write access | Upload folders, work directories |
| `rw` | Read+Write  | General purpose folders |
| `a`  | Admin only  | Sensitive configuration |
| `e`  | Execute     | Scripts, applications |
| `d`  | Delete      | Temporary folders |

## Current Development Folders

The following development folders are already configured:

- `/dev` - Main development directory
- `/dev-apps` - Application development
- `/dev-docs` - Documentation projects  
- `/dev-mcp` - MCP servers and configurations
- `/dev-unsorted` - Unsorted development files
- `/dev-whmcs` - WHMCS modules development

## Best Practices

1. **Use Descriptive Names**: Make URL paths intuitive (e.g., `/projects` not `/proj123`)
2. **Set Appropriate Permissions**: Don't give write access to public folders
3. **Regular Cleanup**: Remove unused volumes to keep the interface clean
4. **Document Changes**: Keep a record of folder additions for team members
5. **Test Access**: Verify folder access works as expected after adding

## Troubleshooting

### Folder Not Showing Up
- Check if the local path exists
- Verify permissions on the local folder
- Restart Copyparty after configuration changes

### Permission Denied
- Ensure the user has appropriate permissions in the volume configuration
- Check file system permissions on the local folder
- Verify user is logged in correctly

### Upload Issues
- Confirm the folder has write permissions
- Check available disk space
- Verify file size limits in configuration

## Advanced Options

### User-Specific Volumes
You can create volumes that only specific users can access:

```
# In configuration file
-v /Users/admin/sensitive:/sensitive:rw --user admin
```

### Temporary Volumes
Create volumes that are only available for the current session:

```bash
python3 ./copyparty-sfx.py \
  -v /tmp/session:/temp:rw \
  --temp-volumes
```

### Volume Aliases
Create multiple access points to the same folder:

```
-v /Users/admin/projects:/projects:rw
-v /Users/admin/projects:/work:rw
```