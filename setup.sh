#!/bin/bash

# Setup script for my_mac_config
# Creates symbolic links from home directory to config files in this repo
# Usage: ./setup.sh [--uninstall]

set -e  # Exit on any error

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for uninstall flag
if [ "$1" = "--uninstall" ]; then
    echo "Uninstalling configuration files..."
    echo ""
    
    # Remove Finicky symlink
    if [ -L "$HOME/.finicky.js" ]; then
        rm "$HOME/.finicky.js"
        echo "✅ Removed ~/.finicky.js"
    else
        echo "ℹ️  ~/.finicky.js not found (already removed or not a symlink)"
    fi
    
    # Remove Hammerspoon symlink
    if [ -L "$HOME/.hammerspoon" ]; then
        rm "$HOME/.hammerspoon"
        echo "✅ Removed ~/.hammerspoon"
    else
        echo "ℹ️  ~/.hammerspoon not found (already removed or not a symlink)"
    fi
    
    echo ""
    echo "Uninstall complete!"
    exit 0
fi

echo "Setting up configuration files from $REPO_DIR"
echo ""

# Check if required applications are installed
echo "Checking for required applications..."

if [ ! -d "/Applications/Finicky.app" ]; then
    echo "❌ Finicky is not installed. Please install it from: https://github.com/johnste/finicky"
    exit 1
else
    echo "✅ Finicky found"
fi

if [ ! -d "/Applications/Hammerspoon.app" ]; then
    echo "❌ Hammerspoon is not installed. Please install it from: https://www.hammerspoon.org/"
    exit 1
else
    echo "✅ Hammerspoon found"
fi

echo ""

# Create symlink for Finicky configuration
echo "Linking Finicky configuration..."
ln -sf "$REPO_DIR/finicky.js" "$HOME/.finicky.js"
echo "  ~/.finicky.js -> $REPO_DIR/finicky.js"

# Create symlink for Hammerspoon configuration
echo "Linking Hammerspoon configuration..."
ln -sf "$REPO_DIR/hammerspoon" "$HOME/.hammerspoon"
echo "  ~/.hammerspoon -> $REPO_DIR/hammerspoon"

echo "Setup complete!"