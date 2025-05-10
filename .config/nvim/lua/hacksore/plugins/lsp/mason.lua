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

    -- Configure diagnostic signs using the new approach
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
      },
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
              diagnostics = {
                globals = { "vim" }
              },
            }
          }
        })
      elseif server == "tailwindcss" then
        lspconfig[server].setup({
          on_attach = function(client, bufnr)
            local tw_highlight = require("tailwind-highlight")
            tw_highlight.setup(client, bufnr, {
              single_column = false,
              mode = "background",
              debounce = 200,
            })
          end,
        })
      end
    end
  end
}
