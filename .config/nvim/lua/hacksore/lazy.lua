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
  print("All lazy plugins:")
  local home = vim.fn.getenv("HOME")
  local file = io.open(home .. "/.config/nvim/lazy-lock.json", "r")
  if not file then
    return
  end

  print(file:read("*a"))
end
