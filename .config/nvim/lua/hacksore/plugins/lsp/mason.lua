local LSP_LIST = {
  "ts_ls",
  "html",
  "cssls",
  "tailwindcss",
  "ruby_lsp",
  "lua_ls",
  "rust_analyzer",
  "dockerls",
  "jsonls",
  "jdtls",
  "docker_compose_language_service",
  "biome",
  "astro",
  "pylsp",
  "yamlls",
  "bashls",
  "graphql",
  "mdx_analyzer",
  "prismals",
}

return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local mason_lspconfig = require('mason-lspconfig')

    local lspconfig = require('lspconfig')
    require('mason').setup()
    mason_lspconfig.setup({
      ensure_installed = LSP_LIST,
      automatic_enable = LSP_LIST
    })

    -- Configure each LSP server
    for _, server in ipairs(LSP_LIST) do
      if server == "rust_analyzer" then
        lspconfig[server].setup({
          on_attach = function()
            -- TODO: allow parsing the closest file rustfmt.toml and parse out tab_spaces=<number>
            -- TODO: is there a way to tell the rust LSP this instead of setting it for neovim overall
            vim.opt.shiftwidth = 2
          end
        })
      elseif server == "biome" then
        lspconfig[server].setup({
          filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescript.tsx", "typescriptreact", "astro", "svelte", "vue", "css" }
        })
      elseif server == "lua_ls" then
        lspconfig[server].setup({
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              format = {
                enable = true,
                defaultConfig = {
                  align_array_table = "false",
                }
              },
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end
    end
  end
}
