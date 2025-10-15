local theme = require("hacksore.core.utils.theme")
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
          light = { colorscheme = theme.LIGHT },
          dark = { colorscheme = theme.DARK },
        },
        -- HACK: for my theme to work for the tab colors
        -- im not sure why this works but it does 😂
        onchange = function(mode)
          if mode == "light" then
            return theme.set_light()
          end

          theme.set_dark()
        end,
      })
    end,
  },
}
