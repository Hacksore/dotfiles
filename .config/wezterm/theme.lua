local wezterm = require("wezterm")

local M = {}

local colors = {
  -- TODO: add light theme
  dark = {
    selection_bg = "#3e4452",
    selection_fg = "#abb2bf",
    cursor_bg = "#abb2bf",
    cursor_fg = "black",
    foreground = "#abb2bf",
    background = "#0D1117",
    ansi = {
      "#4D4D4D",  -- black
      "#e06c75",  -- red
      "#98c379",  -- green
      "#e5c07b",  -- yellow
      "#61afef",  -- blue
      "#c678dd",  -- magenta
      "#56b6c2",  -- cyan
      "#abb2bf",  -- white
    },
    brights = {
      "#4D4D4D",  -- bright black (same as regular black)
      "#e06c75",  -- bright red
      "#98c379",  -- bright green
      "#e5c07b",  -- bright yellow
      "#61afef",  -- bright blue
      "#c678dd",  -- bright magenta
      "#56b6c2",  -- bright cyan
      "#ffffff",  -- bright white
    },
  },
}

local function select_for_appearance(appearance, options)
  if appearance:find("Dark") then
    return options.dark
  else
    return options.light
  end
end

local function tableMerge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        tableMerge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

function M.apply_to_config(c, opts)
  if not opts then
    opts = {}
  end

  -- default options
  local defaults = {
    sync = false,
    color_overrides = { dark = {} },
    token_overrides = { dark = {} },
  }

  local o = tableMerge(defaults, opts)
  local palette = tableMerge(colors, o.color_overrides)

  -- Create color schemes
  local color_schemes = {
    ["Dark Theme"] = palette.dark
  }

  if c.color_schemes == nil then
    c.color_schemes = {}
  end
  c.color_schemes = tableMerge(c.color_schemes, color_schemes)

  if opts.sync then
    c.color_scheme = select_for_appearance(wezterm.gui.get_appearance(), {
      dark = "Dark Theme",
      light = "Dark Theme",
    })
  else
    c.color_scheme = "Dark Theme"
  end

  -- Set window frame colors
  local window_frame = {
    active_titlebar_bg = palette.dark.background,
    active_titlebar_fg = palette.dark.foreground,
    inactive_titlebar_bg = palette.dark.background,
    inactive_titlebar_fg = palette.dark.foreground,
    button_fg = palette.dark.foreground,
    button_bg = palette.dark.background,
  }

  if c.window_frame == nil then
    c.window_frame = {}
  end
  c.window_frame = tableMerge(c.window_frame, window_frame)
end

return M 