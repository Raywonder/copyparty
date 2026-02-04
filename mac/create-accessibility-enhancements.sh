#!/bin/bash

# Copyparty WebUI Accessibility Enhancement Script
# This script adds accesskit.dev compliant accessibility features

COPYPARTY_DIR="$HOME/copyparty"
WEBUI_DIR="$COPYPARTY_DIR/webui-patches"

echo "=== Copyparty WebUI Accessibility Enhancement ==="
echo "Creating accessibility patches based on accesskit.dev standards..."

# Create directory for WebUI patches
mkdir -p "$WEBUI_DIR"

# Create CSS for accessibility improvements
cat > "$WEBUI_DIR/accessibility.css" << 'EOF'
/* Copyparty Accessibility Styles - accesskit.dev compliant */

/* High contrast mode support */
@media (prefers-contrast: high) {
    .file-row, .upload-area, .control-panel {
        border: 2px solid #000;
    }
    
    .button {
        border: 2px solid #000;
        font-weight: bold;
    }
}

/* Focus indicators */
*:focus {
    outline: 3px solid #0066cc;
    outline-offset: 2px;
}

/* Skip links for keyboard navigation */
.skip-link {
    position: absolute;
    top: -40px;
    left: 6px;
    background: #000;
    color: #fff;
    padding: 8px;
    text-decoration: none;
    z-index: 1000;
    transition: top 0.3s;
}

.skip-link:focus {
    top: 6px;
}

/* Screen reader only content */
.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}

/* Improved color contrast */
.text-primary { color: #000; }
.text-secondary { color: #333; }

/* Larger touch targets for mobile */
button, .button, input[type="submit"], input[type="button"] {
    min-height: 44px;
    min-width: 44px;
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
        scroll-behavior: auto !important;
    }
}

/* Better form labels */
.form-group {
    margin-bottom: 1rem;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: bold;
}

.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 0.5rem;
    border: 2px solid #ccc;
    border-radius: 4px;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    border-color: #0066cc;
}

/* Error messages */
.error-message {
    color: #d32f2f;
    font-weight: bold;
    display: block;
    margin-top: 0.25rem;
}

/* Success messages */
.success-message {
    color: #388e3c;
    font-weight: bold;
    display: block;
    margin-top: 0.25rem;
}
EOF

# Create JavaScript for accessibility enhancements
cat > "$WEBUI_DIR/accessibility.js" << 'EOF'
// Copyparty Accessibility JavaScript - accesskit.dev compliant

// Initialize accessibility features
document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Copyparty accessibility features...');
    
    // Add skip links
    addSkipLinks();
    
    // Add ARIA labels
    addARIALabels();
    
    // Enhance keyboard navigation
    enhanceKeyboardNavigation();
    
    // Add live regions for screen readers
    addLiveRegions();
    
    // Add focus management
    manageFocus();
    
    // Add role attributes
    addRoles();
});

// Add skip links for keyboard navigation
function addSkipLinks() {
    const body = document.querySelector('body');
    const skipLinks = document.createElement('div');
    skipLinks.innerHTML = `
        <a href="#main-content" class="skip-link">Skip to main content</a>
        <a href="#navigation" class="skip-link">Skip to navigation</a>
        <a href="#search" class="skip-link">Skip to search</a>
    `;
    body.insertBefore(skipLinks, body.firstChild);
}

// Add ARIA labels and descriptions
function addARIALabels() {
    // File listings
    const fileRows = document.querySelectorAll('.file-row, tr[data-file]');
    fileRows.forEach((row, index) => {
        const fileName = row.querySelector('.file-name, td:first-child');
        if (fileName) {
            const name = fileName.textContent.trim();
            row.setAttribute('aria-label', `File ${name}, row ${index + 1}`);
        }
    });
    
    // Upload buttons
    const uploadButtons = document.querySelectorAll('button[contains(text(), "Upload")], .upload-btn');
    uploadButtons.forEach(button => {
        button.setAttribute('aria-label', 'Upload files to server');
        button.setAttribute('aria-describedby', 'upload-instructions');
    });
    
    // Download buttons
    const downloadButtons = document.querySelectorAll('.download-btn, button[contains(text(), "Download")]');
    downloadButtons.forEach(button => {
        button.setAttribute('aria-label', 'Download selected files');
    });
    
    // Delete buttons
    const deleteButtons = document.querySelectorAll('.delete-btn, button[contains(text(), "Delete")]');
    deleteButtons.forEach(button => {
        button.setAttribute('aria-label', 'Delete selected files');
        button.setAttribute('aria-describedby', 'delete-warning');
    });
    
    // Search form
    const searchInput = document.querySelector('input[type="search"], input[placeholder*="search"], #search');
    if (searchInput) {
        searchInput.setAttribute('aria-label', 'Search files and folders');
        searchInput.setAttribute('aria-describedby', 'search-help');
    }
}

// Enhance keyboard navigation
function enhanceKeyboardNavigation() {
    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl+K for search
        if (e.ctrlKey && e.key === 'k') {
            e.preventDefault();
            const searchInput = document.querySelector('input[type="search"], input[placeholder*="search"], #search');
            if (searchInput) {
                searchInput.focus();
            }
        }
        
        // Escape to close modals
        if (e.key === 'Escape') {
            const modals = document.querySelectorAll('.modal, .dialog');
            modals.forEach(modal => {
                modal.style.display = 'none';
            });
        }
    });
    
    // Make file table keyboard navigable
    const fileTable = document.querySelector('table.files, .file-list');
    if (fileTable) {
        fileTable.setAttribute('role', 'grid');
        fileTable.setAttribute('aria-label', 'File browser');
        
        const rows = fileTable.querySelectorAll('tr');
        rows.forEach((row, index) => {
            row.setAttribute('role', 'row');
            row.setAttribute('aria-rowindex', index + 1);
            
            const cells = row.querySelectorAll('td, th');
            cells.forEach((cell, cellIndex) => {
                cell.setAttribute('role', 'gridcell');
                cell.setAttribute('aria-colindex', cellIndex + 1);
            });
        });
    }
}

// Add live regions for dynamic content
function addLiveRegions() {
    const body = document.querySelector('body');
    
    // Status updates
    const statusRegion = document.createElement('div');
    statusRegion.setAttribute('aria-live', 'polite');
    statusRegion.setAttribute('aria-atomic', 'true');
    statusRegion.setAttribute('class', 'sr-only');
    statusRegion.setAttribute('id', 'status-region');
    body.appendChild(statusRegion);
    
    // Error notifications
    const errorRegion = document.createElement('div');
    errorRegion.setAttribute('aria-live', 'assertive');
    errorRegion.setAttribute('aria-atomic', 'true');
    errorRegion.setAttribute('class', 'sr-only');
    errorRegion.setAttribute('id', 'error-region');
    body.appendChild(errorRegion);
}

// Function to announce status updates
function announceStatus(message, isError = false) {
    const region = document.getElementById(isError ? 'error-region' : 'status-region');
    if (region) {
        region.textContent = message;
        setTimeout(() => {
            region.textContent = '';
        }, 1000);
    }
}

// Add appropriate roles
function addRoles() {
    // Main navigation
    const nav = document.querySelector('nav, .navigation');
    if (nav) {
        nav.setAttribute('role', 'navigation');
        nav.setAttribute('aria-label', 'Main navigation');
    }
    
    // Main content area
    const main = document.querySelector('main, .main-content, #content');
    if (main) {
        main.setAttribute('role', 'main');
        main.setAttribute('id', 'main-content');
    }
    
    // Search form
    const searchForm = document.querySelector('form[action*="search"], .search-form');
    if (searchForm) {
        searchForm.setAttribute('role', 'search');
        searchForm.setAttribute('id', 'search');
    }
    
    // Upload area
    const uploadArea = document.querySelector('.upload-area, .dropzone');
    if (uploadArea) {
        uploadArea.setAttribute('role', 'application');
        uploadArea.setAttribute('aria-label', 'File upload area');
    }
}

// Focus management for modals and dialogs
function manageFocus() {
    // Trap focus within modals
    const modals = document.querySelectorAll('.modal, .dialog');
    modals.forEach(modal => {
        modal.setAttribute('role', 'dialog');
        modal.setAttribute('aria-modal', 'true');
        
        const focusableElements = modal.querySelectorAll(
            'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        );
        
        if (focusableElements.length > 0) {
            modal.addEventListener('keydown', function(e) {
                if (e.key === 'Tab') {
                    const firstElement = focusableElements[0];
                    const lastElement = focusableElements[focusableElements.length - 1];
                    
                    if (e.shiftKey && document.activeElement === firstElement) {
                        e.preventDefault();
                        lastElement.focus();
                    } else if (!e.shiftKey && document.activeElement === lastElement) {
                        e.preventDefault();
                        firstElement.focus();
                    }
                }
            });
        }
    });
}

// Export functions for global access
window.announceStatus = announceStatus;
EOF

# Create HTML template patches
cat > "$WEBUI_DIR/template-patches.html" << 'EOF'
<!-- Copyparty Accessibility Template Patches -->

<!-- Add to head section -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Copyparty - Accessible file sharing server">
<title>Copyparty - File Sharing</title>

<!-- Accessibility CSS -->
<link rel="stylesheet" href="/accessibility.css">

<!-- Skip links -->
<div class="skip-links">
    <a href="#main-content" class="skip-link">Skip to main content</a>
    <a href="#navigation" class="skip-link">Skip to navigation</a>
</div>

<!-- Add ARIA landmarks to main structure -->
<header role="banner">
    <h1>Copyparty File Server</h1>
    <nav role="navigation" aria-label="Main navigation" id="navigation">
        <!-- Navigation content -->
    </nav>
</header>

<main role="main" id="main-content" aria-label="File browser">
    <!-- Main content -->
    
    <!-- Search form with accessibility -->
    <section role="search" aria-label="Search files">
        <form action="/search" method="get" role="search">
            <label for="search-input">Search files and folders</label>
            <input 
                type="search" 
                id="search-input" 
                name="q" 
                aria-describedby="search-help"
                placeholder="Search..."
                autocomplete="off"
            >
            <div id="search-help" class="sr-only">
                Enter search terms to find files and folders. Use * for wildcards.
            </div>
            <button type="submit" aria-label="Submit search">Search</button>
        </form>
    </section>
    
    <!-- File browser with accessibility -->
    <section aria-label="File browser">
        <h2>Files and Folders</h2>
        
        <!-- Upload area -->
        <div 
            class="upload-area" 
            role="application" 
            aria-label="File upload area"
            tabindex="0"
            aria-describedby="upload-instructions"
        >
            <h3>Upload Files</h3>
            <div id="upload-instructions">
                Drag and drop files here or click to select files to upload.
            </div>
            <input 
                type="file" 
                id="file-input" 
                multiple 
                aria-label="Select files to upload"
                style="display: none;"
            >
            <button 
                onclick="document.getElementById('file-input').click()"
                aria-label="Browse and select files to upload"
            >
                Choose Files
            </button>
            <button 
                onclick="uploadFiles()"
                aria-label="Upload selected files to server"
            >
                Upload
            </button>
        </div>
        
        <!-- File table -->
        <table 
            role="grid" 
            aria-label="File listing"
            aria-rowcount="auto"
        >
            <thead>
                <tr role="row">
                    <th scope="col" aria-sort="none" tabindex="0">
                        <button aria-label="Sort by name">Name</button>
                    </th>
                    <th scope="col" aria-sort="none" tabindex="0">
                        <button aria-label="Sort by size">Size</button>
                    </th>
                    <th scope="col" aria-sort="none" tabindex="0">
                        <button aria-label="Sort by date">Modified</button>
                    </th>
                    <th scope="col" scope="col">Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- File rows will be inserted here -->
            </tbody>
        </table>
    </section>
</main>

<!-- Footer -->
<footer role="contentinfo">
    <p>Copyparty File Server - Accessibility Enhanced</p>
</footer>

<!-- Status announcers -->
<div 
    aria-live="polite" 
    aria-atomic="true" 
    class="sr-only"
    id="status-announcer"
></div>
<div 
    aria-live="assertive" 
    aria-atomic="true" 
    class="sr-only"
    id="error-announcer"
></div>

<!-- Accessibility JavaScript -->
<script src="/accessibility.js"></script>
EOF

# Create installation script
cat > "$WEBUI_DIR/install-accessibility.sh" << 'EOF'
#!/bin/bash

# Install accessibility patches for Copyparty

echo "Installing Copyparty accessibility patches..."

WEBUI_DIR="$(dirname "$0")"
COPYPARTY_ROOT="$(dirname "$WEBUI_DIR")"

# Copy CSS and JS files
cp "$WEBUI_DIR/accessibility.css" "$COPYPARTY_ROOT/"
cp "$WEBUI_DIR/accessibility.js" "$COPYPARTY_ROOT/"

echo "Accessibility files copied to $COPYPARTY_ROOT"
echo ""
echo "To enable accessibility features:"
echo "1. Add the CSS and JS references to your HTML templates"
echo "2. Use the template patches in $WEBUI_DIR/template-patches.html"
echo "3. Restart Copyparty to apply changes"
echo ""
echo "For accesskit.dev compliance, ensure:"
echo "- All interactive elements have appropriate ARIA labels"
echo "- Keyboard navigation is fully functional"
echo "- Color contrast ratios meet WCAG 2.1 AA standards"
echo "- Screen reader announcements are provided for dynamic content"
EOF

chmod +x "$WEBUI_DIR/install-accessibility.sh"

echo "✅ Accessibility enhancements created!"
echo ""
echo "Files created:"
echo "- $WEBUI_DIR/accessibility.css"
echo "- $WEBUI_DIR/accessibility.js"
echo "- $WEBUI_DIR/template-patches.html"
echo "- $WEBUI_DIR/install-accessibility.sh"
echo ""
echo "To install accessibility features:"
echo "cd $WEBUI_DIR && ./install-accessibility.sh"