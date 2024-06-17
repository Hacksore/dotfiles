local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Colours
config.colors = {
  selection_bg = "#3e4452",
  selection_fg = "#abb2bf",
  cursor_bg = "#abb2bf",
  cursor_fg = "black",
  foreground = "#abb2bf",
  background = "#21252b",
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
config.enable_tab_bar = false
config.window_padding = {
  left = "0cell",
  right = "0cell",
  top = "0cell",
  bottom = "0cell",
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
}

-- center
wezterm.on("gui-startup", function()
  local screen = wezterm.gui.screens().active
  local _, _, window = wezterm.mux.spawn_window({})

  local gui_window = window:gui_window()

  -- Set dimensions to 85% of current screen size
  -- The actual dimensions will be a bit bigger if we take into
  -- account the decorations on top
  local width = screen.width * 0.85
  local height = screen.height * 0.85

  gui_window:set_inner_size(width, height)

  -- Position the window at the center of the screen
  local dimensions = gui_window:get_dimensions()
  local x = (screen.width - dimensions.pixel_width) * 0.5
  local y = (screen.height - dimensions.pixel_height) * 0.5

  gui_window:set_position(x, y)
end)

return config
