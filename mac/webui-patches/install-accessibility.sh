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
