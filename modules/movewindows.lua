-- Load Lunette for window control
hs.loadSpoon("Lunette")

customBindings = {
    leftHalf = {
      {{"ctrl", "alt"}, "left"},
    },
    rightHalf = {
      {{"ctrl", "alt"}, "right"},
    },
    topHalf = false,
    bottomHalf = false,
    topLeft = {
        {{"ctrl", "alt"}, "u"},
    },
    topRight = {
        {{"ctrl", "alt"}, "up"},
    },
    bottomLeft = {
        {{"ctrl", "alt"}, "j"},
    },
    bottomRight = {
        {{"ctrl", "alt"}, "down"},
    },
    fullScreen = {
        {{"ctrl", "alt", "cmd"}, "up"},
    },
    center = {
        {{"ctrl", "alt"}, "c"},
    },
    nextThird = false,
    prevThird = false,
    enlarge = false,
    shrink = false,
    undo = false,
    redo = false,
    nextDisplay = {
        {{"ctrl", "alt", "cmd"}, "right"},
    },
    prevDisplay = {
        {{"ctrl", "alt", "cmd"}, "left"},
    }
}
spoon.Lunette:bindHotkeys(customBindings)


-- Set custom window movements
print("Custom Window Movements:")

local grid = require "hs.grid"
local mod_resize = {"ctrl", "alt"}
local mod_move   = {"ctrl", "shift"}

grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDHEIGHT = 4
grid.GRIDWIDTH = 2

--resize windows
hs.hotkey.bind(mod_move, 'UP', grid.pushWindowUp) --grid.resizeWindowShorter)
hs.hotkey.bind(mod_move, 'DOWN', grid.pushWindowDown) --grid.resizeWindowTaller)
hs.hotkey.bind(hyper_mod, 'RIGHT', grid.resizeWindowWider)
hs.hotkey.bind(hyper_mod, 'LEFT', grid.resizeWindowThinner)