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
  },

}
