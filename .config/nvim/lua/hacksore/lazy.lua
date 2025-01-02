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

vim.notify("All Lazy.nvim plugins loaded!", vim.log.levels.INFO)
-- if in CI close the nvim after lazy is done loading
if os.getenv("CI") then
  vim.defer_fn(function()
    os.exit(0)
  end, 0)
end
