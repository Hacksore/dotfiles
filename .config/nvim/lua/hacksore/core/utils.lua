local M = {}

M.get_all_colorschemes = function()
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
    local paths = lazy.get_unloaded_rtp ""
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

---@enum Theme (key)
local Theme = {
  light = "github_light_default",
  dark = "github_dark_default",
}

M.Theme = Theme;

---@param theme Theme
M.set_theme = function(theme)
  vim.cmd("colorscheme " .. theme)
end

-- toggle between light and dark themes
M.toggle_theme = function()
  local active_theme = vim.fn.execute("colorscheme"):match("^%s*(.-)%s*$")
  if active_theme == "github_dark_default" or active_theme == "" then
    M.set_theme(Theme.light)
  else
    M.set_theme(Theme.dark)
  end
end

-- make a keybind to toggle themes quicly
local theme_index = 1
M.switch_theme = function(direction)
  local themes = M.get_all_colorschemes()

  theme_index = theme_index + direction

  -- if it underflows go to the end
  if theme_index < 1 then
    theme_index = #themes
  end

  -- if it overflows go to the start
  if theme_index > #themes then
    theme_index = 1
  end

  vim.cmd("colorscheme " .. themes[theme_index])
end

M.has_errors_in_messages = function()
  -- Get the contents of the messages buffer
  local messages_buffer = vim.api.nvim_get_current_buf()
  local messages_lines = vim.api.nvim_buf_get_lines(messages_buffer, 0, -1, false)

  -- Check for error messages (adjust the pattern as needed)
  for _, line in ipairs(messages_lines) do
    if string.match(line, "error") or string.match(line, "Error") then
      return true
    end
  end

  return false
end

---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

return M
