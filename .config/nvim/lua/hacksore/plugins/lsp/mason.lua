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

local rust_utils = require("hacksore.core.rust-utils")

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
      on_attach = function(client, bufnr)
        -- Parse rustfmt.toml to get tab_spaces setting
        local current_file = vim.api.nvim_buf_get_name(bufnr)
        local current_dir = vim.fn.fnamemodify(current_file, ":h")
        local rustfmt_path = rust_utils.find_rustfmt_toml(current_dir)

        local tab_spaces = 2 -- default value
        if rustfmt_path then
          local parsed_tab_spaces = rust_utils.parse_rustfmt_toml(rustfmt_path)
          if parsed_tab_spaces then
            tab_spaces = parsed_tab_spaces
          end
        end

        -- Configure buffer-local settings for this Rust file
        vim.api.nvim_set_option_value('shiftwidth', tab_spaces, { buf = bufnr })
        vim.api.nvim_set_option_value('tabstop', tab_spaces, { buf = bufnr })
        vim.api.nvim_set_option_value('softtabstop', tab_spaces, { buf = bufnr })

        -- Configure rust-analyzer settings
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
      end,
      settings = {
        ["rust-analyzer"] = {
          rustfmt = {
            extraArgs = { "--config-path", vim.fn.getcwd() .. "/rustfmt.toml" }
          }
        }
      }
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
