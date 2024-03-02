local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Colours
config.colors = {
  selection_bg = "#3e4452",
  selection_fg = "#abb2bf",
  cursor_bg = '#abb2bf',
  cursor_fg = 'black',
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
    "#abb2bf"
  },
}

-- Font
config.font = wezterm.font({
  family = "JetBrainsMono Nerd Font",
})

config.font_size = 20.0
config.line_height = 1.1

config.window_close_confirmation = "AlwaysPrompt"
-- config.dpi = 144

config.enable_tab_bar = false;

-- Window
config.window_padding = {
  left = "0cell",
  right = "0cell",
  top = "0.4cell",
  bottom = "0cell",
}

-- the option scripture for good option keys™
config.send_composed_key_when_left_alt_is_pressed = true

-- keys
config.keys = {
  {
    key = "LeftArrow",
    mods = "OPT",
    action = wezterm.action { SendString = "\x1bb" }
  },
  {
    key = "RightArrow",
    mods = "OPT",
    action = wezterm.action { SendString = "\x1bf" }
  },
}

return config
