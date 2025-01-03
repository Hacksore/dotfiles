local utils = require("hacksore.core.utils")
if os.getenv("CI") then
  vim.opt.more = false
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "hacksore.plugins" }, { import = "hacksore.plugins.lsp" } }, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

if os.getenv("CI") then
  -- TODO: check for errors in the message output
  -- send the enter key so it's non-interactive
  vim.api.nvim_input("<CR>")
  vim.defer_fn(function()
    os.exit(0)
  end, 0)
end
