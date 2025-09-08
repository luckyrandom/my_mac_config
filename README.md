# My Mac Config

# Softwares
  - [easy-move-resize](https://github.com/dmarcotte/easy-move-resize) :: Adds "modifier key + mouse drag" move and resize to OSX
  - [Raycast](https://www.raycast.com/) :: Powerful and extensible replacement of spotlight. Shortcut to everything.
  - [Hammerspoon](https://www.hammerspoon.org/) :: A powerful tool for macOS automation that connects the operating system to a Lua scripting engine.
  - [Finicky](https://github.com/johnste/finicky) :: Route urls to the right app.

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

### Configuration Steps

1. **Configure Finicky**: Copy [`finicky.js`](finicky.js) to `~/.finicky.js`
2. **Configure Hammerspoon**: The configuration is already set up in [`hammerspoon/init.lua`](hammerspoon/init.lua) and [`hammerspoon/open_in_chrome.lua`](hammerspoon/open_in_chrome.lua)
