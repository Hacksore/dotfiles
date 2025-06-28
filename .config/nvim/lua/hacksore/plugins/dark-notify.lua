local utils = require("hacksore.core.utils")
-- requires a custom tap but now you can control the theme via switching system theme
-- brew install cormacrelf/tap/dark-notify
-- https://github.com/cormacrelf/dark-notify
-- FIXME: this is kinda scuffed but i want to fix it someda
return {
  {
    enabled = false,
    "cormacrelf/dark-notify",
    config = function()
      print("running dark-notify config")
      require("dark_notify").run({
        onchange = function(mode)
          if mode == "light" then
            utils.set_theme(utils.Theme.light)
          else
            utils.set_theme(utils.Theme.dark)
          end
        end,
      })
    end,
  },
}
