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


return M