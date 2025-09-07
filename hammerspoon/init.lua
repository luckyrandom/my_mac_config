-- hammerspoon configuration file

-- Define hyper key (cmd+ctrl+alt+shift)
local hyper = {"cmd", "ctrl", "alt", "shift"}

-- Reload Hammerspoon configuration
function reloadConfig()
    hs.reload()
end

-- Bind hyper + r to reload configuration
hs.hotkey.bind(hyper, "r", reloadConfig)

-- Show alert when config is loaded
hs.alert.show("Config loaded")
