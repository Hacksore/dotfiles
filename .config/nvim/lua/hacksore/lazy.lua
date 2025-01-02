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

-- if in CI close the nvim after lazy is done loading
if os.getenv("CI") then
  local has_errors = utils.has_errors_in_messages()

  -- send the enter key so it's non-interactive
  vim.api.nvim_input("<CR>")
  vim.defer_fn(function()
    if has_errors then
      -- write to std out there was an error
      vim.api.nvim_out_write("testn")
      return os.exit(1)
    end
    os.exit(0)
  end, 0)
end
