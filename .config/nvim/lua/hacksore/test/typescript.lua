local M = {}

M.run = function()
  local home = vim.fn.getenv("HOME")
  local ts_dir = home .. "/.config/nvim/lua/hacksore/test/__mock__"

  vim.cmd("e " .. ts_dir .. "/typescript.ts")

  -- local is_attached = vim.lsp.util.
  --
  -- print("end of test", is_attached)
end

return M
