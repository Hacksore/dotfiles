return {
  -- gives me nice highlighting for jsx
  {
    "MaxMEllon/vim-jsx-pretty",
    event = "User Astrofile",
  },
  -- add discord presence
  {
    "andweeb/presence.nvim",
    event = "User Astrofile",
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
            ".DS_Store",
          },
        },
      },
    },
  },
  {
    "tpope/vim-surround",
    event = "User Astrofile",
  },
  -- enable github copilot
  {
    "github/copilot.vim",
    event = "User Astrofile",
  },
  -- configure the status line to include the mode as well
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require("astronvim.utils.status")
      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode({ mode_text = { padding = { left = 1, right = 1 } } }), -- add the mode text
        status.component.git_branch(),
        status.component.file_info({ filetype = {}, filename = false, file_modified = false }),
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.treesitter(),
        status.component.nav(),
      }

      -- return the final configuration table
      return opts
    end,
  },
}
