local utils = require("hacksore.core.utils")
---@module "lazy"
---@type LazySpec
return {
  "projekt0n/github-nvim-theme",
  priority = 1000,
  config = function()
    require("github-theme").setup({
      options = {
        terminal_colors = false,
      },
    })
    utils.set_theme(utils.Theme.dark)
  end,
}
