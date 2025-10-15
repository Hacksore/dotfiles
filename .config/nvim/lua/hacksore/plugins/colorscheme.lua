local theme_utils = require("hacksore.core.utils.theme")
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
    theme_utils.set_theme(theme_utils.Theme.dark)
  end,
}
