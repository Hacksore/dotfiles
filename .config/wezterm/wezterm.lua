local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local theme = require("theme")

theme.apply_to_config(config, { sync = true })

-- Codex refreshes its cached OSC 10/11 colors on focus gained, but a macOS
-- appearance change reloads WezTerm's config without changing window focus.
-- Tmux sessions are refreshed separately by tmux-theme-watcher.
wezterm.on("window-config-reloaded", function(_, pane)
  local process = pane:get_foreground_process_name() or ""
  local executable = process:match("([^/]+)$") or process

  if executable:match("^codex") then
    wezterm.time.call_after(0.1, function()
      pane:send_text("\x1b[I")
    end)
  end
end)

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
  -- Early return if window is nil
  if not window then
    return
  end

  wezterm.GLOBAL.windows_centered = wezterm.GLOBAL.windows_centered or {}

  local window_id = window:window_id() .. ""
  if wezterm.GLOBAL.windows_centered[window_id] then
    return
  end

  local screen = wezterm.gui.screens().active

  -- Early return if screen is nil
  if not screen then
    return
  end

  local width = screen.width * 0.85
  local height = screen.height * 0.85

  -- Check if window has the required methods before calling them
  if window.set_inner_size then
    window:set_inner_size(width, height)
  end

  local dimensions = window:get_dimensions()
  local x = (screen.width - dimensions.pixel_width) * 0.5
  local y = (screen.height - dimensions.pixel_height) * 0.5

  wezterm.GLOBAL.windows_centered[window_id] = true

  -- Check if window has set_position method before calling it
  if window.set_position then
    window:set_position(x, y)
  end
end

wezterm.on("update-status", function(window)
  -- Add error handling around the function call
  pcall(center_window_once, window)
end)

wezterm.on("gui-startup", function()
  local _, _, window = wezterm.mux.spawn_window({})
  -- Add error handling around the function call
  pcall(center_window_once, window)
end)

return config
