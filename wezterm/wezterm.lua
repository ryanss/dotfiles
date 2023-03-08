local wezterm = require "wezterm"

---@diagnostic disable-next-line: unused-local
wezterm.on("window-config-reloaded", function(window, pane)
  local windows = wezterm.GLOBAL.windows_loaded or {}
  -- Only run function to resize window once when window created
  if windows[tostring(window:window_id())] ~= nil then return end
  local screen = wezterm.gui.screens().active
  local menu = 76 -- macOS menubar height in retina pixels on MacBook Pro 14" screen
  if screen.height == 2880 then menu = 50 end -- macOS menubar height on external 4k monitor
  window:set_inner_size(screen.width * 0.8, (screen.height - menu) * 0.8)
  window:set_position(screen.width * 0.1, (screen.height - menu) * 0.1 + menu)
  -- Mark window as loaded so it is not resized again during use
  windows[tostring(window:window_id())] = true
  wezterm.GLOBAL.windows_loaded = windows
end)

local function change_opacity(window, delta)
  local overrides = window:get_config_overrides() or {}
  local opacity = overrides.window_background_opacity or 1.00
  opacity = math.min(math.max(opacity + delta, 0.50), 1.00)
  overrides.window_background_opacity = opacity
  window:set_config_overrides(overrides)
end
wezterm.on("opacity-decrease", function(window) change_opacity(window, -0.02) end)
wezterm.on("opacity-increase", function(window) change_opacity(window,  0.02) end)


return {
  -- Font
  font = wezterm.font "CaskaydiaCove Nerd Font Mono",
  font_size = 20,
  line_height = 1.1,
  adjust_window_size_when_changing_font_size = false,

  -- Colors
  color_scheme = "nord",
  colors = {
    background = "#232731",  -- nord0 default: #2E3440
  },

  -- Windows
  window_background_opacity = 1.00,
  window_decorations = "RESIZE",

  -- Tabs
  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,

  -- Misc
  window_close_confirmation = "NeverPrompt",

  -- Key Binds
  keys = {
    { key = "-", mods = "CTRL", action = wezterm.action.EmitEvent("opacity-decrease") },
    { key = "=", mods = "CTRL", action = wezterm.action.EmitEvent("opacity-increase") },
  },
}
