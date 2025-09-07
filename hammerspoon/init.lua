-- hammerspoon configuration file

-- Define hyper key (cmd+ctrl+alt+shift)
local hyper = {"cmd", "ctrl", "alt", "shift"}

-- Reload Hammerspoon configuration
function reloadConfig()
    hs.reload()
end

-- Bind hyper + r to reload configuration
hs.hotkey.bind(hyper, "r", reloadConfig)

-- Get detailed info of the topmost window
function getWindowInfo()
    local win = hs.window.focusedWindow()
    if win then
        local app = win:application()
        local frame = win:frame()
        local screen = win:screen()
        
        local info = string.format([[
Window Details:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Application: %s
Window Title: %s
Bundle ID: %s
PID: %d
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Position: (%.0f, %.0f)
Size: %.0f × %.0f
Screen: %s
Minimized: %s
Full Screen: %s
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━]], 
            app:name(),
            win:title() or "No title",
            app:bundleID() or "Unknown",
            app:pid(),
            frame.x, frame.y,
            frame.w, frame.h,
            screen:name(),
            win:isMinimized() and "Yes" or "No",
            win:isFullScreen() and "Yes" or "No"
        )
        
        -- Also print to console for reference
        print(info)
        hs.alert.show("Window Info printed to the Hammerspoon console", 2)
    else
        hs.alert.show("No focused window found", 2)
    end
end

-- Bind hyper + w to get window info
hs.hotkey.bind(hyper, "w", getWindowInfo)

-- Show alert when config is loaded
hs.alert.show("Config loaded")
