local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.colors = {
  selection_bg = "#3e4452",
  selection_fg = "#abb2bf",
  cursor_bg = "#abb2bf",
  cursor_fg = "black",
  foreground = "#abb2bf",
  background = "#0D1117",
  ansi = {
    "#21252b",
    "#e06c75",
    "#98c379",
    "#e5c07b",
    "#61afef",
    "#c678dd",
    "#56b6c2",
    "#abb2bf",
  },
  brights = {
    "#767676",
    "#e06c75",
    "#98c379",
    "#e5c07b",
    "#61afef",
    "#c678dd",
    "#56b6c2",
    "#abb2bf",
  },
}

-- Font
config.font = wezterm.font({
  family = "JetBrainsMono Nerd Font",
  weight = "DemiBold",
})
config.font_size = 20.0

-- Window
config.window_close_confirmation = "AlwaysPrompt"
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.window_padding = {
  left = "0.5cell",
  right = "0.5cell",
  top = "0.5cell",
  bottom = "0.5cell",
}

-- the option scripture for good option keys™
config.send_composed_key_when_left_alt_is_pressed = true

-- keys
config.keys = {
  {
    key = "LeftArrow",
    mods = "OPT",
    action = wezterm.action({ SendString = "\x1bb" }),
  },
  {
    key = "RightArrow",
    mods = "OPT",
    action = wezterm.action({ SendString = "\x1bf" }),
  },
  -- allow control + k to move up
  {
    key = "K",
    mods = "CTRL",
    action = wezterm.action.SendKey { key = "K", mods = "CTRL" }
  },
  -- shell to redraw its prompt
  {
    key = "k",
    mods = "SUPER",
    action = act.Multiple({
      act.ClearScrollback("ScrollbackAndViewport"),
      act.SendKey({ key = "L", mods = "CTRL" }),
    }),
  },
}

local function center_window_once(window)
  wezterm.GLOBAL.windows_centered = wezterm.GLOBAL.windows_centered or {}

  local window_id = window:window_id() .. ""
  if wezterm.GLOBAL.windows_centered[window_id] then
    return
  end

  local screen = wezterm.gui.screens().active


  local width = screen.width * 0.85
  local height = screen.height * 0.85

  if screen and window then
    window:set_inner_size(width, height)
  end

  local dimensions = window:get_dimensions()
  local x = (screen.width - dimensions.pixel_width) * 0.5
  local y = (screen.height - dimensions.pixel_height) * 0.5

  wezterm.GLOBAL.windows_centered[window_id] = true

  window:set_position(x, y)
end

wezterm.on("update-status", function(window)
  center_window_once(window)
end)

wezterm.on("gui-startup", function()
  local _, _, window = wezterm.mux.spawn_window({})
  center_window_once(window)
end)

return config
