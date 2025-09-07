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

-- Focus existing app window in current space or launch new
-- @param appName: Name of the application to focus/launch
-- @param dockMenuItemName: Optional menu item name in Dock context menu (defaults to "New Window")
function focusOrNewAppWin(appName, dockMenuItemName)
    local currentSpace = hs.spaces.focusedSpace()
    local app = hs.application.get(appName)
    
    if app then
        -- App is running, check for windows in current space
        local windows = app:allWindows()
        local windowInCurrentSpace = nil
        
        for _, win in pairs(windows) do
            if win:isVisible() then
                local winSpaces = hs.spaces.windowSpaces(win)
                if winSpaces and hs.fnutils.contains(winSpaces, currentSpace) then
                    windowInCurrentSpace = win
                    break
                end
            end
        end
        
        if windowInCurrentSpace then
            -- Focus existing window in current space
            windowInCurrentSpace:focus()
            return
        else
            -- App running but no window in current space, create new window via Dock
            -- Using Dock context menu instead of "tell application ... make new window" to avoid switching workspaces
            -- when the app has windows open in other spaces.
            local menuItem = dockMenuItemName or "New Window"
            local script = string.format([[
                try
                    tell application "System Events"
                        tell process "Dock"
                            set appIcon to first UI element of list 1 whose title is "%s"
                            perform action "AXShowMenu" of appIcon
                            delay 0.2
                            click menu item "%s" of menu 1 of appIcon
                        end tell
                    end tell
                on error
                    -- Fallback to direct app command
                    tell application "%s" to make new window
                end try
            ]], appName, menuItem, appName)
            hs.osascript.applescript(script)
            return
        end
    else
        -- App not running, launch it in current workspace
        hs.application.open(appName)
    end
end

-- Example bindings (uncomment and customize as needed)
hs.hotkey.bind(hyper, "t", function() focusOrNewAppWin("iTerm", "New Window (Default Profile)") end)
hs.hotkey.bind(hyper, "c", function() focusOrNewAppWin("Google Chrome") end)

-- Show alert when config is loaded
hs.alert.show("Config loaded")
