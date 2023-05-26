return {
  "jay-babu/mason-null-ls.nvim",
  opts = {
    handlers = {
      -- for prettier
      prettier = function()
        local nullLs = require("null-ls")
        nullLs.register(nullLs.builtins.formatting.prettier.with({
          condition = function(utils)
            return utils.root_has_file("package.json")
                or utils.root_has_file(".prettierrc")
                or utils.root_has_file(".prettierrc.json")
                or utils.root_has_file(".prettierrc.js")
          end,
        }))
      end,
    },
  },
}
