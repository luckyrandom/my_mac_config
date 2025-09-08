# My Mac Config

# Softwares
  - [easy-move-resize](https://github.com/dmarcotte/easy-move-resize) :: Adds "modifier key + mouse drag" move and resize to OSX
  - [Raycast](https://www.raycast.com/) :: Powerful and extensible replacement of spotlight. Shortcut to everything.
  - [Hammerspoon](https://www.hammerspoon.org/) :: A powerful tool for macOS automation that connects the operating system to a Lua scripting engine.
  - [Finicky](https://github.com/johnste/finicky) :: Route urls to the right app.

# Setup Steps
**You should alway proof read before install any script.**

**Quick Setup:**
```bash
git clone https://github.com/luckyrandom/my_mac_config.git
cd my_mac_config
./setup.sh
```

The setup script will:
- Check that Finicky and Hammerspoon are installed
- Create symbolic links: `~/.finicky.js` → `finicky.js` and `~/.hammerspoon` → `hammerspoon/`
- Provide next steps for completing the setup

**Manual Setup:**
1. **Configure Finicky**: Copy or soft link [`finicky.js`](finicky.js) to `~/.finicky.js`
2. **Configure Hammerspoon**: Copy or soft link [`hammerspoon/`](hammerspoon/) to `~/.hammerspoon`

**Uninstall:**
```bash
./setup.sh --uninstall
```


# Open URL in Chrome in the Current Workspace

## Problem It Solves
This is actually a macOS behavior issue, not Chrome-specific. When clicking links from other applications, macOS opens the URL in whatever workspace the target browser was last active in, forcing you to switch workspaces to see the new tab. We focus on Chrome here because it's commonly used for opening URLs from other apps, and the constant workspace switching disrupts your workflow by taking you away from your current context.

## How It Works
The core idea is simple: when you want to open a URL in your current workspace, you would manually bring Chrome to the front (Cmd+Tab) or right-click the Dock → Chrome → "New Window", then paste the URL. We automate this manual process using tools:

**The automated flow:**
1. **Finicky intercepts URLs**: All URL clicks are routed through a custom `hammerspoon://` protocol instead of going directly to Chrome
2. **Hammerspoon brings Chrome to current workspace**: Uses `focusOrNewAppWin()` to bring Chrome to your current workspace (or launch it if not running)
3. **Wait for Chrome activation**: Sets up a watcher to detect when Chrome becomes active
4. **Open URL directly**: Uses AppleScript `tell application "Google Chrome" open location` to open the URL

## Setup Requirements

### Prerequisites
- [Hammerspoon](https://www.hammerspoon.org/) installed and running
- [Finicky](https://github.com/johnste/finicky) installed as your default browser
- Google Chrome pinned to the Dock (required for creating new windows in current workspace)
- **Accessibility permissions for Hammerspoon**: System Preferences → Security & Privacy → Privacy → Accessibility → Add Hammerspoon (required for Dock interaction)
- **Automation permissions for Hammerspoon**: Allow Hammerspoon to control Chrome when prompted (required for opening URLs)

## Standalone Setup (Chrome URL Handling Only)

If you only want the Chrome URL handling feature without other configurations:

### Prerequisites
- [Hammerspoon](https://www.hammerspoon.org/) installed and running
- [Finicky](https://github.com/johnste/finicky) installed as your default browser
- Google Chrome pinned to the Dock
- Accessibility permissions for Hammerspoon in System Preferences
- Automation permissions for Hammerspoon (will be prompted)

### Setup Steps
1. **Download required files:**
   - [`finicky.js`](finicky.js)
   - [`hammerspoon/open_in_chrome.lua`](hammerspoon/open_in_chrome.lua)
   - [`hammerspoon/win.lua`](hammerspoon/win.lua)

2. **Install Finicky config:**
   ```bash
   cp finicky.js ~/.finicky.js
   ```

3. **Install Hammerspoon modules:**
   ```bash
   mkdir -p ~/.hammerspoon
   cp open_in_chrome.lua ~/.hammerspoon/
   cp win.lua ~/.hammerspoon/
   ```

4. **Add to your Hammerspoon init.lua:**
   ```lua
   local openInChrome = require('open_in_chrome')
   openInChrome.enableUrlEventHandling()
   ```

5. **Reload Hammerspoon configuration**
