-- Caps Lock acts as Escape when pressed
-- and activates hyper mode when held down
local hyper = hs.hotkey.modal.new()

for _, mods in ipairs({'', 'cmd', 'shift'}) do
  hs.hotkey.bind(mods, 'F18',
    function() -- pressedfn
      hyper:enter()
      hyper.triggered = false
    end,
    function() -- releasedfn
      hyper:exit()
      if not hyper.triggered then
        hs.eventtap.keyStroke('', 'escape')
      end
    end
  )
end

local function hyperBind(mods, key, pressedfn, repeatfn)
  hyper:bind(mods, key,
    function() -- pressedfn
      hyper.triggered = true
      pressedfn()
    end,
    nil, -- releasedfn
    function() -- repeatfn
      if repeatfn == true then
        pressedfn()
      elseif repeatfn ~= nil then
        repeatfn()
      end
    end)
end


-- Move windows
local function bindWindowMove(key, unitrect)
  hyperBind('cmd', key, function()
    hs.window.focusedWindow():moveToUnit(unitrect)
  end)
end

bindWindowMove('q', {0.0, 0.0, 0.5, 0.5}) -- Top left
bindWindowMove('w', {0.0, 0.0, 1.0, 0.5}) -- Top half
bindWindowMove('e', {0.5, 0.0, 0.5, 0.5}) -- Top right
bindWindowMove('a', {0.0, 0.0, 0.5, 1.0}) -- Left half
bindWindowMove('s', {0.2, 0.0, 0.6, 1.0}) -- Center half
bindWindowMove('d', {0.5, 0.0, 0.5, 1.0}) -- Right half
bindWindowMove('z', {0.0, 0.5, 0.5, 0.5}) -- Bottom left
bindWindowMove('x', {0.0, 0.5, 1.0, 0.5}) -- Bottom half
bindWindowMove('c', {0.5, 0.5, 0.5, 0.5}) -- Bottom right
bindWindowMove('f', {0.0, 0.0, 1.0, 1.0}) -- Full screen
bindWindowMove('g', {0.1, 0.1, 0.8, 0.8}) -- Center screen


-- Focus windows
local function bindWindowFocus(key, direction)
  hyperBind('cmd', key, function()
    hs.window.focusedWindow()['focusWindow' .. direction](nil, true)
  end)
end

bindWindowFocus('h', 'West')
bindWindowFocus('j', 'South')
bindWindowFocus('k', 'North')
bindWindowFocus('l', 'East')


-- Vim keybinds while in hyper mode
local function map(keys, pressedfn, repeatfn)
  local mods = {}
  if keys ~= string.lower(keys) then
    table.insert(mods, 'shift')
  end
  hyperBind(mods, keys, pressedfn, repeatfn)
end

local function keyStroke(mods, char, nohyper)
  if nohyper then hyper:exit() end
  hs.eventtap.keyStroke(mods, char, 0)
  if nohyper then hyper:enter() end
end

local NOHYPER = true
local REPEAT = true

map('h', function() keyStroke('', 'left' ) end, REPEAT)
map('j', function() keyStroke('', 'down' ) end, REPEAT)
map('k', function() keyStroke('', 'up'   ) end, REPEAT)
map('l', function() keyStroke('', 'right') end, REPEAT)

map('0', function() keyStroke('cmd', 'left' ) end)
map('4', function() keyStroke('cmd', 'right') end)

map('g', function() keyStroke('cmd', 'up'  ) end)
map('G', function() keyStroke('cmd', 'down') end)

map('b', function() keyStroke('alt', 'left' ) end, REPEAT)
map('e', function() keyStroke('alt', 'right') end, REPEAT)
map('w', function() keyStroke('alt', 'right')
                    keyStroke('alt', 'right')
                    keyStroke('alt', 'left' ) end, REPEAT)

map('u', function() keyStroke('cmd',       'z', NOHYPER) end)
map('r', function() keyStroke('shift,cmd', 'z', NOHYPER) end)


-- Copy Mail.app message link to clipboard
hyperBind('cmd', 'm', function()
  local script = [[
    tell application "Mail"
      set emails to selection
      set email to item 1 of emails
      set msgid to message id of email
      set subj to subject of email
      set the clipboard to "✉️ " & subj & "\nmessage://%3c" & msgid & "%3e"
    end tell
  ]]
  hs.osascript.applescript(script)
  hs.alert("Copied email link to clipboard")
end)

-- Insert current date in Things
hyperBind('cmd', '.', function()
  hs.eventtap.keyStrokes(" [" .. os.date("%m/%d/%Y") .. "]")
end)

-- Show Tyme menu
hyperBind('cmd', 't', function()
  hyper:exit()
  hs.eventtap.keyStroke({'shift', 'ctrl', 'alt', 'cmd'}, 't')
end)

-- Reload Hammerspoon
hyperBind('cmd', 'r', hs.reload)

hs.alert.show('Hammerspoon Loaded')
