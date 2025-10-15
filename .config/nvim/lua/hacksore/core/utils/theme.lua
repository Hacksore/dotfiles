local M = {}

--- Get a list of available colorschemes
--- @returns string[]
M.colorschemes = function()
  local before_color = vim.api.nvim_exec2("colorscheme", { output = true }).output

  local colors = { before_color }
  if not vim.tbl_contains(colors, before_color) then
    table.insert(colors, 1, before_color)
  end

  colors = vim.list_extend(
    colors,
    vim.tbl_filter(function(color)
      return not vim.tbl_contains(colors, color)
    end, vim.fn.getcompletion("", "color"))
  )

  -- if lazy is available, extend the colors list with unloaded colorschemes
  local lazy = package.loaded["lazy.core.util"]
  if lazy and lazy.get_unloaded_rtp then
    local paths = lazy.get_unloaded_rtp("")
    local all_files = vim.fn.globpath(table.concat(paths, ","), "colors/*", true, true)
    for _, f in ipairs(all_files) do
      local color = vim.fn.fnamemodify(f, ":t:r")
      if not vim.tbl_contains(colors, color) then
        table.insert(colors, color)
      end
    end
  end

  return colors
end

M.LIGHT = "github_light_default"
M.DARK = "github_dark_default"

--- Set the colorscheme
--- @param theme string
--- @returns nil
M.set = function(theme)
  vim.cmd("colorscheme " .. theme)
end

--- Set the light theme
M.set_light = function()
  return M.set(M.LIGHT)
end

--- Set the dark theme
M.set_dark = function()
  return M.set(M.DARK)
end

--- Toggle between light and dark themes
--- @returns nil
M.toggle = function()
  local active_theme = vim.fn.execute("colorscheme"):match("^%s*(.-)%s*$")
  if active_theme == M.DARK or active_theme == "" then
    M.set(M.LIGHT)
  else
    M.set(M.DARK)
  end
end

local _internal_theme_index = 1
--- Switch to the next or previous colorscheme
--- @param direction number 1 for next, -1 for previous
--- @returns nil
M.switch = function(direction)
  local themes = M.colorschemes()

  _internal_theme_index = _internal_theme_index + direction

  -- if it underflows go to the end
  if _internal_theme_index < 1 then
    _internal_theme_index = #themes
  end

  -- if it overflows go to the start
  if _internal_theme_index > #themes then
    _internal_theme_index = 1
  end

  vim.cmd("colorscheme " .. themes[_internal_theme_index])
end

return M
