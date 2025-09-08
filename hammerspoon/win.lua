local M = {}

-- Focus existing app window in current space or launch new
-- @param appName: Name of the application to focus/launch
-- @param dockMenuItemName: Optional menu item name in Dock context menu (defaults to "New Window")
function M.focusOrNewAppWin(appName, dockMenuItemName)
    local currentSpace = hs.spaces.focusedSpace()
    local app = hs.application.get(appName)
    
    if app then
        -- App is running, check for windows in current space
        local windows = app:allWindows()
        local visibleWindowInCurrentSpace = nil
        local invisibleWindowInCurrentSpace = nil
        
        for _, win in pairs(windows) do
            local winSpaces = hs.spaces.windowSpaces(win)
            if winSpaces and hs.fnutils.contains(winSpaces, currentSpace) then
                if win:isVisible() then
                    visibleWindowInCurrentSpace = win
                    break
                else
                    invisibleWindowInCurrentSpace = win
                end
            end
        end
        
        if visibleWindowInCurrentSpace then
            -- Focus existing visible window in current space
            visibleWindowInCurrentSpace:focus()
            return
        elseif invisibleWindowInCurrentSpace then
            -- Make invisible window visible and focus it
            invisibleWindowInCurrentSpace:becomeMain()
            invisibleWindowInCurrentSpace:focus()
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

return M