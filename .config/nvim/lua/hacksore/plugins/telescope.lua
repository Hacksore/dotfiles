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

    local telescope_config = require("telescope.config")
    local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
    table.insert(vimgrep_arguments, "--hidden")
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!.git/*")
    table.insert(vimgrep_arguments, "--trim")
    table.insert(vimgrep_arguments, "--sort")
    table.insert(vimgrep_arguments, "path")

    telescope.setup({
      pickers = {
        find_files = {
          find_command = {
            "fd",
            "--hidden",
            "--type", "f",
            "--follow",
            "--no-ignore-vcs",
            -- NOTE: this is good for allow me to find .env files
            -- but it means this list will become crazy, maybe i need to have
            -- another hotkey to search over exlucded files or something?
            "--exclude", ".git/",
            "--exclude", "dist/",
            "--exclude", "build/",
            "--exclude", "node_modules/",
          }
        },
      },
      defaults = {
        path_display = { "smart" },
        vimgrep_arguments = vimgrep_arguments,
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
    keymap.set("n", "<Leader>fw", builtin.live_grep, { desc = "Find word under cursor" })
  end,
}
