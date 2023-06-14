return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "lua_ls",
        "cssls",
        "dockerls",
        "html",
        "jsonls",
        "rust_analyzer",
        "tsserver",
        "voler",
        "yamlls",
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "eslint_d",
        "prettier",
        "beautysh"
      },
    },
  }
}
