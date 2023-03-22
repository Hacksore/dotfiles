return {
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
  {
    "github/copilot.vim",
    lazy = false
  }
}
