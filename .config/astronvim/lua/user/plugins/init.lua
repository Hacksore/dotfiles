return {
  -- gives me nice highlighting for jsx
  {
    "MaxMEllon/vim-jsx-pretty",
    event = "User Astrofile"
  },
  -- add discord presence
  {
    "andweeb/presence.nvim",
    event = "User Astrofile"
  },
  -- get tree to shows hidden files
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            ".git",
            ".DS_Store"
          },
        },
      },
    },
  },
  {
    "tpope/vim-surround",
    event = "User Astrofile"
  },
  {
    "github/copilot.vim",
    event = "User Astrofile"
  }
}
