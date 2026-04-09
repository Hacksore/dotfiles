-- set this before lazy and core load
vim.g.mapleader = " "

-- Homebrew is often absent from PATH when Neovim runs from GUI apps (Cursor, Dock). nvim-treesitter
-- needs the `tree-sitter` CLI (install: `brew install tree-sitter` or `npm i -g tree-sitter-cli`).
-- Health reports "tree-sitter-cli not found" when `tree-sitter` is missing from PATH.
do
  local prepend = {}
  for _, p in ipairs({
    "/opt/homebrew/bin",
    "/opt/homebrew/opt/tree-sitter/bin",
    "/usr/local/bin",
    "/usr/local/opt/tree-sitter/bin",
    "/home/linuxbrew/.linuxbrew/bin",
  }) do
    if vim.fn.isdirectory(p) == 1 then
      prepend[#prepend + 1] = p
    end
  end
  if #prepend > 0 then
    vim.env.PATH = table.concat(prepend, ":") .. ":" .. (vim.env.PATH or "")
  end

  if vim.fn.executable("tree-sitter") ~= 1 then
    local home = vim.env.HOME or vim.fn.expand("~")
    for _, exe in ipairs({
      home .. "/.local/bin/tree-sitter",
      home .. "/.cargo/bin/tree-sitter",
    }) do
      if vim.fn.executable(exe) == 1 then
        vim.env.PATH = vim.fn.fnamemodify(exe, ":h") .. ":" .. vim.env.PATH
        break
      end
    end
  end
end

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
