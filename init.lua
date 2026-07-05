-- Load local configs/plugins
require("modules.automations")
require("modules.hotkeys")
require("modules.text_transforms")

-- Reload config on file changes
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
