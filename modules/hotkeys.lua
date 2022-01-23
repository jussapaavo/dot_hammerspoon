-- Launch apps with a hotkey
-- Note: Use Apparency to find bundle IDs
-- Note: Match application name to the first menu item name of the app
-- Inspiration from: https://github.com/evantravers/hammerspoon-config
Config = {}
Config.applications = {
    ["kitty"] = {
        bundleID = "net.kovidgoyal.kitty",
        hyperKey = "1",
    },
    ["Code"] = {
        bundleID = "com.microsoft.VSCode",
        hyperKey = "2",
    },
    ["Chrome"] = {
        bundleID = "com.google.Chrome",
        hyperKey = "3"
    },
    ["Drafts"] = {
        bundleID = "com.agiletortoise.Drafts-OSX",
        hyperKey = "d",
        localBindings = {"d"}
    },
    ["Finder"] = {
        bundleID = "com.apple.finder",
        hyperKey = "f"
    },
    ["Spotify"] = {
        bundleID = "com.spotify.client",
        hyperKey = "s"
    },
}

-- Initial config for Hyper
Hyper = hs.loadSpoon("Hyper")
Hyper:bindHotKeys({hyperKey = {{}, "F19"}})

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
hs.fnutils.each(Config.applications, function(appConfig)

    if appConfig.hyperKey then
        if appConfig.bundleID == "com.apple.finder" then
            Hyper:bind({}, appConfig.hyperKey, function() launch_finder(appConfig.bundleID); end)
        else
            Hyper:bind({}, appConfig.hyperKey, function() launch_application(appConfig.bundleID) end)
        end
    end

    if appConfig.localBindings then
        hs.fnutils.each(appConfig.localBindings, function(key)
            Hyper:bindPassThrough(key, appConfig.bundleID)
        end)
    end
end)

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
    toggle = {{"cmd", "alt", "ctrl"}, "m"}
}
spoon.MicMute:bindHotkeys(customBindings, 1)

-- Hotkey for forcing Spotify playpause from media key
hs.hotkey.bind({"cmd"}, "f8", function() hs.spotify.playpause(); end)