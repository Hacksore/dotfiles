local make_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.offsetEncoding = "utf-16"
  return capabilities
end

return {
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
    config = function()
      require("lspconfig").jsonls.setup({
        capabilities = make_capabilities(),
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
          },
        },
      })
    end,
  },
}
