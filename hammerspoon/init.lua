-- Hammerspoon configuration file

-- Load utility functions
local utils = require('utils')

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

-- Show alert when config is loaded
hs.alert.show("Config loaded")
