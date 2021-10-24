-- Hammerspoon with:
-- - Reload Configuration
-- - Lunette (Window manager)
-- - MicMute
-- - Caffeine
-- - Commander
-- - Seal
-- - Shade
-- - SpoonInstall

-- Ideas:
-- - Focus on video meeting window (Teams, Google Meets, Zoom) with a hotkey
-- - Reload Hammerspoon config with a hotkey
-- - Intelligent window movement (if at half size, move window to up or bottom third / corner) Solution maybe here? https://github.com/wangshub/hammerspoon-config/blob/master/window/window.lua
-- - Headspaces: http://evantravers.com/articles/2021/03/20/headspace-v1-0/
-- - Open new window in Finder if not active in current space

hyper_mod = {"shift", "ctrl", "alt", "cmd"}

-- Load local configs/plugins
hyper = require("hyper")
require("movewindows")
require("hotkeys")
--require("debug")

-- Reload config on file changes
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()