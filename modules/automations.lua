watcher = hs.caffeinate.watcher.new(
    function(eventType)
        if (
            eventType == hs.caffeinate.watcher.systemDidWake or
            eventType == hs.caffeinate.watcher.screensDidUnlock
            --eventType == hs.caffeinate.watcher.screensDidWake
        )
        then
            -- Restart Kanata
            hs.execute("kanata-service restart", true)
            print("Wakeup: Restarted Kanata")
            -- Restart BetterMouse
            hs.osascript.applescript([[quit app "BetterMouse"]])
            hs.osascript.applescript([[tell application "BetterMouse" to activate]])
            print("Wakeup: Restarted BetterMouse")
        end
    end
)
watcher:start()
