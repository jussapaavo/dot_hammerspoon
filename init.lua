-- Ideas:
-- - Reload Hammerspoon config with a hotkey
-- - Focus on video meeting window (Teams, Google Meets, Zoom) with a hotkey, see here for a solution: https://github.com/evantravers/hammerspoon-config/tree/master/Spoons/Teamz.spoon
-- - Intelligent window movement (if at half size, move window to up or bottom third / corner) Solution maybe here? https://github.com/wangshub/hammerspoon-config/blob/master/window/window.lua
-- - Implement Headspaces: http://evantravers.com/articles/2021/03/20/headspace-v1-0/
-- - Install new Spoons:
--   - Caffeine
--   - Commander
--   - Seal
--   - Shade
--   - SpoonInstall

-- Load local configs/plugins
hyper = require("modules.hyper")
require("modules.movewindows")
require("modules.hotkeys")
--require("modules.debug")

-- Reload config on file changes
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()