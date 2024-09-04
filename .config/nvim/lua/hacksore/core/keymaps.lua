vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<Leader>ff", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Telescope find files" })
keymap.set("n", "<Leader>gg", "<cmd>silent !tmux neww lazygit<cr>", { desc = "Open lazygit in tmux" })
