-- HYPER
--
-- Hyper is a hyper shortcut modal. Basically you can use `F19` as a new modal key to fire
-- Hammerspoon-powered OSX automation. However, you need some other app or tool to change a key on your keyboard
-- to input `F19`. I use `hidutil` directly to change my caps-lock key to function as `F19`.
-- Read more here: http://evantravers.com/articles/2020/06/08/hammerspoon-a-better-better-hyper-key/

local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function()
  hyper:enter()
end

hyper.released = function()
  hyper:exit()
end

-- Set the key you want to be HYPER to F19 in karabiner or keyboard
-- Bind the Hyper key to the hammerspoon modal
hs.hotkey.bind({}, 'F19', hyper.pressed, hyper.released)

return hyper