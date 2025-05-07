local wezterm = require("wezterm")

local M = {}

local colors = {
  dark = {
    selection_bg = "#3e4452",
    selection_fg = "#abb2bf",
    cursor_bg = "#abb2bf",
    cursor_fg = "black",
    foreground = "#abb2bf",
    background = "#0D1117",
    ansi = {
      "#2c313a",
      "#e06c75",
      "#98c379",
      "#e5c07b",
      "#61afef",
      "#c678dd",
      "#56b6c2",
      "#abb2bf",
    },
    brights = {
      "#2c313a",
      "#e06c75",
      "#98c379",
      "#e5c07b",
      "#61afef",
      "#c678dd",
      "#56b6c2",
      "#abb2bf",
    },
  },
  light = {
    selection_bg = "#3e4452",
    selection_fg = "#abb2bf",
    cursor_bg = "#abb2bf",
    cursor_fg = "black",
    foreground = "#abb2bf",
    background = "#0D1117",
    ansi = {
      "#2c313a",
      "#e06c75",
      "#98c379",
      "#e5c07b",
      "#61afef",
      "#c678dd",
      "#56b6c2",
      "#abb2bf",
    },
    brights = {
      "#2c313a",
      "#e06c75",
      "#98c379",
      "#e5c07b",
      "#61afef",
      "#c678dd",
      "#56b6c2",
      "#abb2bf",
    },
  }
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
    color_overrides = { dark = {}, light = {} },
    token_overrides = { dark = {}, light = {} },
  }

  local o = tableMerge(defaults, opts)
  local palette = tableMerge(colors, o.color_overrides)

  -- Create color schemes for both dark and light modes
  local color_schemes = {
    ["Dark Theme"] = palette.dark,
    ["Light Theme"] = palette.light
  }

  if c.color_schemes == nil then
    c.color_schemes = {}
  end
  c.color_schemes = tableMerge(c.color_schemes, color_schemes)

  if opts.sync then
    c.color_scheme = select_for_appearance(wezterm.gui.get_appearance(), {
      dark = "Dark Theme",
      light = "Light Theme",
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