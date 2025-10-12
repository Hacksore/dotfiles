return {
  "sindrets/diffview.nvim",
  opts = function()
    return {
      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
      },
    }
  end,
  keys = {
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffviewFileHistory %" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "DiffviewFileHistory" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
  },
}
