local theme = require("hacksore.core.utils.theme")
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
    theme.set(theme.DARK)
  end,
}
