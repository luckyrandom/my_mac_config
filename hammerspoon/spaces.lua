local M = {}

local spaceNames

local function showSpaceNameInMenuBar()
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


function M.init(loadedSpaceNames)
    spaceNames = loadedSpaceNames
    showSpaceNameInMenuBar()
end

return M
