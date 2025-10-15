local theme_utils = require("hacksore.core.utils.theme")
-- brew install cormacrelf/tap/dark-notify
-- https://github.com/cormacrelf/dark-notify
---@module "lazy"
---@type LazySpec
return {
  {
    "cormacrelf/dark-notify",
    config = function()
      require("dark_notify").run({
        schemes = {
          light = { colorscheme = theme_utils.Theme.light },
          dark = { colorscheme = theme_utils.Theme.dark },
        },
        -- HACK: for my theme to work for the tab colors
        -- im not sure why this works but it does 😂
        onchange = function(mode)
          if mode == "light" then
            return theme_utils.set_theme(theme_utils.Theme.light)
          end

          theme_utils.set_theme(theme_utils.Theme.dark)
        end,
      })
    end,
  },
}
