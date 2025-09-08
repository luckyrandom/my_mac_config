-- Utility functions for Hammerspoon configuration

local M = {}

-- Get detailed info of the topmost window
function M.getWindowInfo()
    local win = hs.window.focusedWindow()
    if win then
        local app = win:application()
        local frame = win:frame()
        local screen = win:screen()
        
        -- Get workspace information
        local winSpaces = hs.spaces.windowSpaces(win)
        local currentSpace = hs.spaces.focusedSpace()
        local workspaceInfo = "Unknown"
        
        if winSpaces and #winSpaces > 0 then
            local spaceNames = {}
            for _, spaceId in pairs(winSpaces) do
                local spaceName = string.format("Space %d", spaceId)
                table.insert(spaceNames, spaceName .. (spaceId == currentSpace and " (current)" or ""))
            end
            workspaceInfo = table.concat(spaceNames, ", ")
        end
        
        local info = string.format([[
Window Details:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Application: %s
Window Title: %s
Bundle ID: %s
PID: %d
━━━━━━━━━━━━━━━━━━━━━━━━━━━━��━━━━━━━━━━━
Position: (%.0f, %.0f)
Size: %.0f × %.0f
Screen: %s
Workspaces: %s
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
            workspaceInfo,
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

-- Focus existing app window in current space or launch new
-- @param appName: Name of the application to focus/launch
-- @param dockMenuItemName: Optional menu item name in Dock context menu (defaults to "New Window")
function M.focusOrNewAppWin(appName, dockMenuItemName)
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

-- Show current space name in the menu bar
function M.showSpaceNameInMenuBar(spaceNames)
    -- Create a menu bar item
    local spaceMenu = hs.menubar.new()

    -- Function to update the menu bar item with the a new space name
    local function updateSpaceName()
        local currentSpace = hs.spaces.focusedSpace()
        local spaceName = spaceNames[currentSpace] or "Space " .. currentSpace
        spaceMenu:setTitle(spaceName)
    end

    -- Function to build the menu
    local function buildMenu()
        return {
            {
                title = "Rename Current Space",
                fn = function()
                    local currentSpace = hs.spaces.focusedSpace()
                    local currentName = spaceNames[currentSpace] or ("Space " .. currentSpace)
                    local button, newName = hs.dialog.textPrompt(
                        "Rename Space " .. currentSpace,
                        "Enter the new name for this space:",
                        currentName,
                        "OK",
                        "Cancel"
                    )

                    if button == "OK" and newName and newName ~= "" then
                        spaceNames[currentSpace] = newName
                        hs.settings.set("spaceNames", spaceNames) -- Save the updated table
                        updateSpaceName() -- Immediately update the menu bar title
                    end
                end
            },
            { title = "-" },
            { title = "Reload Config", fn = function() hs.reload() end }
        }
    end

    -- Set the menu
    spaceMenu:setMenu(buildMenu())

    -- Initial update
    updateSpaceName()

    -- Subscribe to space change events
    hs.spaces.watcher.new(updateSpaceName):start()
end

return M