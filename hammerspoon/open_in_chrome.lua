local M = {}

local win = require('win')

-- Enable URL event handling for Finicky integration
-- Sets up hs.urlevent.bind to handle "openInChrome" events
function M.enableUrlEventHandling()
    local logger = hs.logger.new('urlevent', 'info')
    hs.urlevent.bind("openInChrome", function(eventName, params)
        logger.i("Received URL event: " .. eventName .. " with params: " .. hs.inspect(params))
        if params and params.url then
            logger.i("Opening URL in Chrome: " .. params.url)
            M.OpenInChromeCurrWorkspace(params.url)
        end
    end)
end

-- Open a URL in Chrome, focusing/launching it in the current workspace first.
-- @param url: The URL to open.
function M.OpenInChromeCurrWorkspace(url)
    local appName = "Google Chrome"
    local watcher

    local function openUrlInChrome()
        local script = string.format([[
            tell application "Google Chrome"
                open location "%s"
            end tell
        ]], url)
        hs.osascript.applescript(script)
    end

    local function appActivated(activatedAppName, eventType, appObject)
        if eventType == hs.application.watcher.activated and activatedAppName == appName then
            openUrlInChrome()
            -- Stop the watcher once our task is done
            if watcher then
                watcher:stop()
                watcher = nil
            end
        end
    end

    -- Check if Chrome is already the frontmost app
    local focusedApp = hs.application.frontmostApplication()
    if focusedApp and focusedApp:name() == appName then
        openUrlInChrome()
        return
    end

    -- If not, set up a watcher and focus the app
    watcher = hs.application.watcher.new(appActivated)
    watcher:start()
    local logger = hs.logger.new('urlevent', 'info')
    logger.i("Focusing or launching " .. appName .. " to open URL: " .. url)
    win.focusOrNewAppWin(appName)

    -- Add a timeout to stop the watcher if Chrome doesn't activate within 10 seconds
    hs.timer.doAfter(10, function()
        if watcher then
            watcher:stop()
            watcher = nil
        end
    end)
end

return M