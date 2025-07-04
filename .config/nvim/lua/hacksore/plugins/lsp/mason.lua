local LSP_LIST = {
  "denols",
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
    "princejoogie/tailwind-highlight.nvim"
  },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")

    require("mason").setup()

    local filtered_lsp_list = {}
    local lsps_to_skip = {
      "denols",
      "ts_ls",
    }

    for _, lsp in ipairs(LSP_LIST) do
      if not vim.tbl_contains(lsps_to_skip, lsp) then
        table.insert(filtered_lsp_list, lsp)
      end
    end

    mason_lspconfig.setup({
      ensure_installed = LSP_LIST,
      automatic_enable = filtered_lsp_list
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
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Configure each LSP server
    lspconfig.rust_analyzer.setup({
      on_attach = function()
        -- TODO: allow parsing the closest file rustfmt.toml and parse out tab_spaces=<number>
        -- TODO: is there a way to tell the rust LSP this instead of setting it for neovim overall
        vim.opt.shiftwidth = 2
      end
    })

    lspconfig.biome.setup({
      filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescript.tsx", "typescriptreact", "astro", "svelte", "vue", "css" }
    })

    lspconfig.bashls.setup({
      -- allow attching when .zshrc
      filetypes = { "sh", "zsh" }
    })

    lspconfig.yamlls.setup({
      settings = {
        yaml = {
          format = {
            enable = true
          },
        }
      }
    })

    lspconfig.tailwindcss.setup({
      on_attach = function(client, bufnr)
        local tw_highlight = require("tailwind-highlight")
        tw_highlight.setup(client, bufnr, {
          single_column = false,
          mode = "background",
          debounce = 200,
        })
      end,
    })

    lspconfig.denols.setup({
      root_dir = function(fname)
        return lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock")(fname)
      end,
      filetypes = {},
      single_file_support = false,
      settings = {},
    })

    lspconfig.ts_ls.setup({
      root_dir = function(fname)
        local deno_root = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock")(fname)
        if deno_root then
          return nil
        end

        return lspconfig.util.root_pattern("tsconfig.json", "package.json")(fname)
      end,
      filetypes = {},
      single_file_support = false,
      settings = {},
    })
  end
}
