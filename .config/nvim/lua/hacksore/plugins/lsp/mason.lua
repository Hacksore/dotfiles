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
    mason_lspconfig.setup({
      ensure_installed = LSP_LIST,
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

    -- setup deno first
    lspconfig.denols.setup({
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
      single_file_support = false,
      settings = {},
    })

    -- force ts lsp to only if tsconfig.json is present and not in a deno project
    lspconfig.ts_ls.setup({
      root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json"),
      single_file_support = false,
      settings = {},
      on_attach = function(client, bufnr)
        print("ts_ls attached to " .. vim.api.nvim_buf_get_name(bufnr))
        vim.notify("ts_ls attached to " .. vim.api.nvim_buf_get_name(bufnr), vim.log.levels.INFO)
        local denoRootDir = lspconfig.util.root_pattern("deno.json", "deno.lock", "deno.jsonc")(vim.api.nvim_buf_get_name(bufnr))
        if denoRootDir then
          client.stop() -- Force stop the client if we detect we're in a Deno project
        end
      end,
    })
  end
}
