local ENABLED_LANGUAGE_SERVERS = {
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

local configure_dianostics = function()
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
end

return {
  "mason-org/mason.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
    "princejoogie/tailwind-highlight.nvim"
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = ENABLED_LANGUAGE_SERVERS,
    })

    -- Configure each LSP server using native vim.lsp.configure
    configure_dianostics()

    vim.lsp.config("rust_analyzer", {
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

    vim.lsp.config("biome", {
      filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescript.tsx", "typescriptreact", "astro", "svelte", "vue", "css" }
    })

    vim.lsp.config("bashls", {
      filetypes = { "sh", "zsh" }
    })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          format = {
            enable = true
          },
        }
      }
    })

    vim.lsp.config("tailwindcss", {
      on_attach = function(client, bufnr)
        local tw_highlight = require("tailwind-highlight")
        tw_highlight.setup(client, bufnr, {
          single_column = false,
          mode = "background",
          debounce = 200,
        })
      end,
    })

    vim.lsp.config("denols", {
      root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
      workspace_required = true,
    })

    vim.lsp.config("ts_ls", {
      root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
      workspace_required = true,
    })

    for _, lsp in ipairs(ENABLED_LANGUAGE_SERVERS) do
      vim.lsp.enable(lsp)
    end
  end
}
