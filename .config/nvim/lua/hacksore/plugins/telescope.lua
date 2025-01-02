return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    local trouble_telescope = require("trouble.sources.telescope")

    telescope.setup({
      pickers = {
        grep_string = {
          additional_args = { "--hidden" }
        },
        live_grep = {
          additional_args = { "--hidden" }
        },
        find_files = {
          find_command = {
            "fd",
            "--hidden",
            "--type", "f",
            "--follow",
            "--exclude", ".git/",
            "--exclude", "dist/",
            "--exclude", "build/",
            "--exclude", "node_modules/",
          }
        },
      },
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-t>"] = trouble_telescope.open,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<Leader>b", builtin.buffers, { desc = "Telescope buffers" })
    keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Telescope find files" })
    keymap.set("n", "<Leader>fc", builtin.grep_string, { desc = "Find word under cursor" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set("n", "<Leader>fw", builtin.live_grep, { desc = "Find words" })
  end,
}
