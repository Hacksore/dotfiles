vim.g.mapleader = " "

local keymap = vim.keymap

-- tmux and lazygit
keymap.set("n", "<Leader>ff", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Telescope find files" })
keymap.set("n", "<Leader>gg", "<cmd>silent !tmux neww lazygit<cr>", { desc = "Open lazygit in tmux" })
keymap.set("n", "<C-n>", function()
	vim.fn.system("tmux switch-client -n")
end, { desc = "Switch tmux session forward" })
keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<cr>", { desc = "Open tmux sessionizer" })

keymap.set("n", "<C-p>", function()
	vim.fn.system("tmux switch-client -p")
end, { desc = "Switch tmux session back" })

-- neotree
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
keymap.set("n", "<Leader>tv", "<Cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "ToggleTerm vert" })

keymap.set("t", "<C-H>", "<Cmd>wincmd h<CR>", { desc = "Terminal left window navigation" })
keymap.set("t", "<C-J>", "<Cmd>wincmd j<CR>", { desc = "Terminal down window navigation" })
keymap.set("t", "<C-K>", "<Cmd>wincmd k<CR>", { desc = "Terminal up window navigation" })
keymap.set("t", "<C-L>", "<Cmd>wincmd l<CR>", { desc = "Terminal right window navigation" })

-- format
keymap.set("n", "<Leader>lf", function()
	vim.lsp.buf.format()
end, { desc = "Format buffer" })

-- lsp things
keymap.set("n", "<Leader>ld", function()
	vim.diagnostic.open_float()
end, { desc = "Hover diagnostics" })

-- random things
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- navigation
keymap.set("n", "<Leader>p", "<Cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<Leader>n", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
