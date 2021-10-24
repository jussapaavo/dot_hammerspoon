-- Launch apps with a hotkey
-- Note: Use Apparency to find bundle IDs
-- Note: Match application name to the first menu item name of the app
-- Inspiration from: https://github.com/evantravers/hammerspoon-config/blob/38a7d8c0ad2190d1563d681725628e4399dcbe6c/hyper.lua
config = {}
config.applications = {
    ['kitty'] = {
        bundleID = 'net.kovidgoyal.kitty',
        hotkey = '1',
        tags = {'#coding'}
    },
    ['Code'] = {
        bundleID = "com.microsoft.VSCode",
        hotkey = "2",
        tags = {'#coding'}
    },
    ['Chrome'] = {
        bundleID = "com.google.Chrome",
        hotkey = "3"
    },
    ['Finder'] = {
        bundleID = "com.apple.finder",
        hotkey = "f"
    },
    ['Spotify'] = {
        bundleID = 'com.spotify.client',
        hotkey = "s"
    },
}

-- Define function for launching applications
launch_application = function(app_bundleID)
    local app = hs.application.get(app_bundleID)
    if app then
        if app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
        hs.application.launchOrFocusByBundleID(app_bundleID)
    end
end

-- Special function for opening Finder
launch_finder = function(app_bundleID)
    local app = hs.application.get(app_bundleID)
    if app then
        local window_count = #app:visibleWindows()

        if window_count == 1 then
            hs.osascript.applescript([[tell application id "com.apple.finder" to make new Finder window to home]])
        elseif app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
        hs.application.launchOrFocusByBundleID(app_bundleID)
    end
end

-- Bind hotkeys for launching applications
for app_name, app_config in pairs(config.applications) do

    local app_bundleID = app_config.bundleID
    local hotkey = app_config.hotkey

    print("AppLauncher: " .. app_name)

    if app_name == "Finder" then
        hyper:bind({}, hotkey, function() launch_finder(app_bundleID); end)
    else
        hyper:bind({}, hotkey, function() launch_application(app_bundleID); end)
    end
end

-- Custom hotkey for Finder to open files in VSCode
print("Set hotkey for opening files in VS Code")

local script_to_open_path = [[set output to ""
tell application "Finder" to set the_selection to selection
set item_count to count the_selection
repeat with item_index from 1 to count the_selection
  if item_index is less than item_count then set the_delimiter to "\n"
  if item_index is item_count then set the_delimiter to ""
  set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
end repeat
tell application id "com.microsoft.VSCode"
    open output
    activate
end tell]]

function if_finder_then_open_file_in_vscode()
    local app = hs.application.get("com.apple.finder")

    if app:isFrontmost() then
        hs.osascript.applescript(script_to_open_path)
    end
end
hs.hotkey.bind({"cmd", "alt"}, "down", if_finder_then_open_file_in_vscode)

-- Custom hotkey for toggling caps lock
print("Set hotkey for toggling caps lock")
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f19", function() hs.hid.capslock.toggle(); end)

-- Global hotkey for muting microphone
hs.loadSpoon("MicMute")
customBindings = {
    toggle = {{"ctrl", "cmd", "alt"}, "m"}
}
spoon.MicMute:bindHotkeys(customBindings, 1)

