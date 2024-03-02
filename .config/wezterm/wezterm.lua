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

config.font_size = 18.0
config.line_height = 1.1

config.window_close_confirmation = "AlwaysPrompt"
config.dpi = 144

config.enable_tab_bar = false;

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0
}

return config
