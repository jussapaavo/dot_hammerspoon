--TEST
hyper:bind({}, 'z', nil, function() print("Hyper is pressed!!") end)

-- Get bundleID for an app
for app_name, app_config in pairs(config.applications) do
    local bundleID = app_config.bundleID
    local hotkey = app_config.hotkey

    print("App Debugger: " .. app_name)

    hyper:bind({'shift'}, hotkey, function()
        local app = hs.application.get(app_name)
        if app then
            print( "BudleID for " .. app_name .. " is: " .. app:bundleID() )
        end
    end)
end