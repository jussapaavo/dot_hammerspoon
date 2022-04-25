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
        {{"ctrl", "alt"}, "i"},
    },
    bottomLeft = {
        {{"ctrl", "alt"}, "j"},
    },
    bottomRight = {
        {{"ctrl", "alt"}, "k"},
    },
    fullScreen = {
        {{"ctrl", "alt", "cmd"}, "up"},
    },
    center = {
        {{"ctrl", "alt"}, "up"},
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