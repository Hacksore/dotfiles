-- set this before lazy and core load
vim.g.mapleader = " "

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

require("hacksore.lazy")
require("hacksore.core")

-- NOTE: allows for yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch" })
  end,
})

vim.api.nvim_set_hl(0, "LazyGitBorder", { fg = "#0D1117", bg = "none" })
