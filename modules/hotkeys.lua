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
    ["Bear"] = {
        bundleID = "net.shinyfrog.bear",
        hyperKey = "b",
        localBindings = {"n"}
    },
    ["Drafts"] = {
        bundleID = "com.agiletortoise.Drafts-OSX",
        hyperKey = "d",
        localBindings = {"d"}
    },
    ["Finder"] = {
        bundleID = "com.apple.finder",
        hyperKey = "a"
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
        -- Special case for Finder
        if app_bundleID == "com.apple.finder" then
            local window_count = #app:visibleWindows()
            if window_count == 1 then
                hs.osascript.applescript([[tell application id "com.apple.finder" to make new Finder window to home]])
            end
        -- Special case for Kitty
        elseif app_bundleID == "net.kovidgoyal.kitty" then
            local window_count = #app:allWindows()
            if window_count == 0 then
                hs.osascript.applescript([[
                tell application "System Events" to tell process "kitty"
                    click menu item "New OS Window" of menu 1 of menu bar item "Shell" of menu bar 1
                    activate
                end tell]])
            end
        end

        if app:isFrontmost() then
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
        Hyper:bind({}, appConfig.hyperKey, function() launch_application(appConfig.bundleID) end)
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

-- Hotkey for forcing Spotify playpause from media key
Hyper:bind({"cmd"}, "s", function() hs.spotify.playpause(); end)

-- Hotkey for muting Teams & Zoom
function toggleMute()
    local teams = hs.application.get("com.microsoft.teams2")
    local zoom = hs.application.get("us.zoom.xos")
    if not (teams == null) then
        hs.eventtap.keyStroke({"cmd","shift"}, "m", 0, teams)
    end
    if not (zoom == nil) then
        hs.eventtap.keyStroke({"cmd","shift"}, "a", 0, zoom)
    end
end

Hyper:bind({"cmd"}, "m", toggleMute)
