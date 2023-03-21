return {
  -- any 
  options = {
    opt = {
      showtabline = 0, -- don't show tabline
      spell = true, -- Enable spell checking 
    },
  },
  -- LSP to setup
  lsp = {
    servers = {
      "bashls",
      "cssls",
      "eslint",
      "html",
      "jsonls",
      "rust_analyzer",
      "tsserver",
      "yamlls",
    },
  },
  mappings = {
    n = {
      ["<leader>ff"] = {"<cmd>Telescope git_files<cr>", desc = "Telescope git files" }
    },
  },
  plugins = {
    -- why can't I get this working better™?
    {
      "tpope/vim-fugitive",
      cmd = "Git"
    },
    -- gives me nice highlighting for jsx
    {
      "MaxMEllon/vim-jsx-pretty",
      lazy = false
    },
    -- add discord presence
    {
      "andweeb/presence.nvim",
      lazy = false,
    },
    -- get tree to shows hidden files
    {
      "nvim-neo-tree/neo-tree.nvim",
      cmd = "Neotree",
      opts = {
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_by_name = {
              ".git"
            },
          },
        },
      },
    },
    -- attempt to configure null-ls
    -- ["null-ls"] = function(config)
    --   local null_ls = require("null-ls")
    --   config.sources = {
    --     null_ls.builtins.formatting.prettier,
    --   }
    --   config.on_attach = function(client)
    --     if client.supports_method("textDocument/formatting") then
    --       vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    --       vim.api.nvim_create_autocmd("BufWritePre", {
    --         group = augroup,
    --         buffer = bufnr,
    --         callback = function()
    --           vim.lsp.buf.format({ bufnr = bufnr })
    --         end,
    --       })
    --     end
    --   end
    --   return config -- return final config table
    -- end,
  },
}
