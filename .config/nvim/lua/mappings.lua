return {
  v = {
    -- stop making the pasted text go into my clipboard buffer
    p = {
      [["_dP]], -- this goes to narnia (aka the void)
    },
  },
  n = {
    ["<leader>ff"] = { "<cmd>Telescope find_files hidden=true<cr>", desc = "Telescope find files" },
    ["<leader>gg"] = { "<cmd>silent !tmux neww lazygit<cr>", desc = "Open lazygit" },
    ["<leader>1"] = { "<cmd>bprevious<cr>", desc = "Switch buffer backwards" },
    ["<leader>2"] = { "<cmd>bnext<cr>", desc = "Switch buffer forward" },
    ["<leader>h"] = false,
    -- NOTE: this is a bunch of stuff for tmux
    ["<C-n>"] = {
      function()
        vim.fn.system("tmux switch-client -n")
      end,
      desc = "Switch tmux session forward",
    },
    ["<C-p>"] = {
      function()
        vim.fn.system("tmux switch-client -p")
      end,
      desc = "Switch tmux session back",
    },
    -- open the fuzzy menu for finding projects
    ["<C-f>"] = { "<cmd>silent !tmux neww tmux-sessionizer<cr>", desc = "Open tmux sessionizer" },
    -- test auto import
    ["<leader>ll"] = {
      function()
        vim.lsp.buf.code_action({
          context = { only = { "source.addMissingImports" }, triggerKind = 1 },
          apply = true,
        })
      end,
      desc = "test null code",
    },
  },
}
