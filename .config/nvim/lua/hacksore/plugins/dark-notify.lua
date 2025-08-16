local utils = require("hacksore.core.utils")
-- brew install cormacrelf/tap/dark-notify
-- https://github.com/cormacrelf/dark-notify
return {
  {
    "cormacrelf/dark-notify",
    config = function()
      require("dark_notify").run({
        schemes = {
          light = { colorscheme = utils.Theme.light },
          dark  = { colorscheme = utils.Theme.dark },
        },
        -- HACK: im not sure why this works but it does, so im happy with it
        onchange = function(mode)
          if (mode == "light") then
            utils.set_theme(utils.Theme.light)
          else
            utils.set_theme(utils.Theme.dark)
          end
        end,
      })
    end,
  },
}
