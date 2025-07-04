return {
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
    config = function()
      require("lspconfig").jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            enable = false,
          },
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      })
    end,
  },
}
