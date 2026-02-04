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
