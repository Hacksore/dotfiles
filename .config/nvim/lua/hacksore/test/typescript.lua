local M = {}

M.run = function()
  local home = vim.fn.getenv("HOME")
  local ts_dir = home .. "/.config/nvim/lua/hacksore/test/__mock__/typescript.ts"
  vim.cmd("e " .. ts_dir)

  -- check if there are diagnostics 
  local diagnostics = vim.lsp.diagnostic.get(0)

  print(vim.inspect(diagnostics))

end

return M
