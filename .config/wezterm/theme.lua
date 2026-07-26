local wezterm = require("wezterm")

local M = {}

local colors = {
  light = {
    selection_bg = "#b6d7ff",
    selection_fg = "#1f2328",
    cursor_bg = "#1f2328",
    cursor_fg = "#ffffff",
    foreground = "#1f2328",
    background = "#ffffff",
    ansi = {
      "#24292f", -- black
      "#cf222e", -- red
      "#116329", -- green
      "#4d2d00", -- yellow
      "#0969da", -- blue
      "#8250df", -- magenta
      "#1b7c83", -- cyan
      "#6e7781", -- white
    },
    brights = {
      "#57606a", -- bright black
      "#a40e26", -- bright red
      "#1a7f37", -- bright green
      "#633c01", -- bright yellow
      "#218bff", -- bright blue
      "#a475f9", -- bright magenta
      "#3192aa", -- bright cyan
      "#8c959f", -- bright white
    },
  },
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

local function get_appearance()
  -- wezterm.gui is unavailable when the config is evaluated by a mux server.
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end

  return "Dark"
end

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
    color_overrides = { light = {}, dark = {} },
  }

  local o = tableMerge(defaults, opts)
  local palette = tableMerge(colors, o.color_overrides)
  local appearance = get_appearance()

  -- Create color schemes
  local color_schemes = {
    ["Light Theme"] = palette.light,
    ["Dark Theme"] = palette.dark,
  }

  if c.color_schemes == nil then
    c.color_schemes = {}
  end
  c.color_schemes = tableMerge(c.color_schemes, color_schemes)

  if o.sync then
    c.color_scheme = select_for_appearance(appearance, {
      dark = "Dark Theme",
      light = "Light Theme",
    })
  else
    c.color_scheme = "Dark Theme"
  end

  -- Set window frame colors
  local frame_palette = palette.dark
  if o.sync then
    frame_palette = select_for_appearance(appearance, palette)
  end

  local window_frame = {
    active_titlebar_bg = frame_palette.background,
    active_titlebar_fg = frame_palette.foreground,
    inactive_titlebar_bg = frame_palette.background,
    inactive_titlebar_fg = frame_palette.foreground,
    button_fg = frame_palette.foreground,
    button_bg = frame_palette.background,
  }

  if c.window_frame == nil then
    c.window_frame = {}
  end
  c.window_frame = tableMerge(c.window_frame, window_frame)
end

return M
