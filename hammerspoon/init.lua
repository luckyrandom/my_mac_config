-- Hammerspoon configuration file

-- Load utility functions
local utils = require('utils')

local spaces = require('spaces')

-- Define hyper key (cmd+ctrl+alt+shift)
local hyper = {"cmd", "ctrl", "alt", "shift"}

-- Reload Hammerspoon configuration
function reloadConfig()
    hs.reload()
end

-- Key bindings
hs.hotkey.bind(hyper, "r", reloadConfig)
hs.hotkey.bind(hyper, "w", utils.getWindowInfo)

-- App launcher bindings
hs.hotkey.bind(hyper, "t", function() utils.focusOrNewAppWin("iTerm", "New Window (Default Profile)") end)
hs.hotkey.bind(hyper, "c", function() utils.focusOrNewAppWin("Google Chrome") end)
hs.hotkey.bind(hyper, "o", function() utils.OpenInChromeCurrWorkspace("https://www.hammerspoon.org/docs/") end)

-- URL handler for Finicky
local logger = hs.logger.new('urlevent', 'info')
hs.urlevent.bind("openInChrome", function(eventName, params)
    logger.i("Received URL event: " .. eventName .. " with params: " .. hs.inspect(params))
    if params and params.url then
        logger.i("Opening URL in Chrome: " .. params.url)
        utils.OpenInChromeCurrWorkspace(params.url)
    end
end)

-- Show alert when config is loaded
hs.alert.show("Config loaded")

-- Show space name in menu bar
-- Load space names from settings, or create a default set if none exist
local spaceNames = hs.settings.get("spaceNames")
if not spaceNames then
    spaceNames = {
        "1: Web",
        "2: Term",
        "3: Code",
        "4: Chat",
        "5: Notes",
        "6: Slack",
        "7: Mail",
        "8: Music",
        "9: System",
        "10:Games"
    }
    hs.settings.set("spaceNames", spaceNames)
end
spaces.init(spaceNames)

