local AUTO_INSTALL_LANGUAGE_SERVERS = {
  "denols",
  "ts_ls",
  "eslint",
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
  opts = {
    ensure_installed = AUTO_INSTALL_LANGUAGE_SERVERS
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
    "princejoogie/tailwind-highlight.nvim",
  },
  config = function()
    local is_ci = vim.env.CI == "1"
    local language_servers = is_ci and AUTO_INSTALL_LANGUAGE_SERVERS or {}

    require("mason").setup({})
    require("mason-lspconfig").setup({
      ensure_installed = language_servers,
    })

    vim.diagnostic.config({ signs = { text = { " ", " ", " ", " " } } })

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

    for _, lsp in ipairs(AUTO_INSTALL_LANGUAGE_SERVERS) do
      vim.lsp.enable(lsp)
    end
  end
}
