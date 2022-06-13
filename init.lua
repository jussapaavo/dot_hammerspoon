-- Load local configs/plugins
require("modules.hotkeys")

-- Reload config on file changes
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()