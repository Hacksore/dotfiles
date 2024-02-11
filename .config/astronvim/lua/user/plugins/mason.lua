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
        "marksman",
        "rust_analyzer",
        "ruby_ls",
        "jdtls",
        "tailwindcss",
        "tsserver",
        "vuels",
        "astro",
        "docker_compose_language_service",
        "eslint",
        "gopls",
        "graphql",
        "prismals",
        "pylsp",
        "yamlls",
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "shfmt"
      },
    },
  }
}
