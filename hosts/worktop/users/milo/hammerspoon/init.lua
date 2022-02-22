-- Hammerspoon config from Nix

print('Loading hammerspoon buddy')

local getKeyCode = function(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.keyStroke(modifiers, key)
   end
end

local appWatcher = hs.application.watcher.new(function(name, type, appObj)
  if name == 'Alacritty' and type == hs.application.watcher.activated then
    print('deactivate keybindings here')
  else
    print('activate keybindings here')
  end
end)

appWatcher:start()

local remapKey = function(modifiers, key, keyCode)
  print("remapping key", modifiers, key, keyCode)
  hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

-- remapKey({'ctrl'}, 'h', getKeyCode('left'))
-- remapKey({'ctrl'}, 'j', getKeyCode('down'))
-- remapKey({'ctrl'}, 'k', getKeyCode('up'))
-- remapKey({'ctrl'}, 'l', getKeyCode('right'))

local reloadConfig = function(files)
  local doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

local hsWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

hs.notify.show("Hammerspoon", "Config loaded", "Probably from Nix")

