return {
  "jay-babu/mason-null-ls.nvim",
  opts = {
    handlers = {
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
