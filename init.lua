-- Load local configs/plugins
require("modules.movewindows")
require("modules.hotkeys")

-- Force Spotify control from media keys
hs.loadSpoon("SpotifyMediaFix")
spoon.SpotifyMediaFix:start()

-- Reload config on file changes
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()