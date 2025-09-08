-- Hammerspoon configuration file

-- Load utility functions
local utils = require('utils')
local win = require('win')
local openInChrome = require('open_in_chrome')
local spaces = require('spaces')

-- Enable Chrome URL handling with Finicky integration
openInChrome.enableUrlEventHandling()

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
hs.hotkey.bind(hyper, "t", function() win.focusOrNewAppWin("iTerm", "New Window (Default Profile)") end)
hs.hotkey.bind(hyper, "c", function() win.focusOrNewAppWin("Google Chrome") end)
hs.hotkey.bind(hyper, "o", function() openInChrome.OpenInChromeCurrWorkspace("https://www.hammerspoon.org/docs/") end)


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

