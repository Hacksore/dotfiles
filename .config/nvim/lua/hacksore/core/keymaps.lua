vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<Leader>ff", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Telescope find files" })
keymap.set("n", "<Leader>gg", "<cmd>silent !tmux neww lazygit<cr>", { desc = "Open lazygit in tmux" })

keymap.set("n", "<Leader>e", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Explorer" })
keymap.set("n", "<Leader>o", function()
	if vim.bo.filetype == "neo-tree" then
		vim.cmd.wincmd("p")
	else
		vim.cmd.Neotree("focus")
	end
end, {
	desc = "Toggle Explorer Focus",
})

-- toggle term keys
keymap.set("n", "<Leader>tf", "<Cmd>ToggleTerm direction=float<CR>", { desc = "ToggleTerm float" })
keymap.set("n", "<Leader>th", "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", { desc = "ToggleTerm horiz" })
keymap.set("n", "<Leader>tf", "<Cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "ToggleTerm vert" })
