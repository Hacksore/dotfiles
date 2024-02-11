return {
  "jay-babu/mason-null-ls.nvim",
  opts = {
    handlers = {
      -- for prettier
      prettier = function()
        local nullLs = require("null-ls")
        nullLs.register(nullLs.builtins.formatting.prettier.with({
          condition = function(utils)
            local files = {
              "package.json",
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.js",
              "prettier.config.js",
              "prettier.config.cjs",
              ".prettierrc.cjs",
            }
            return utils.root_has_file(files)
          end,
        }))
      end,
      beautysh = function()
        local nullLs = require("null-ls")
        nullLs.register(nullLs.builtins.formatting.beautysh.with({
          args = {
            "--indent-size",
            "2",
            "$FILENAME",
          },
        }))
      end,
    },
  },
}
