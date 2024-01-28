return {
	v = {
		-- stop making the pasted text go into my clipboard buffer
		p = {
			[["_dP]] -- this goes to narnia (aka the void)
		}
	},
	n = {
		["<leader>ff"] = { "<cmd>Telescope find_files hidden=true<cr>", desc = "Telescope find files" },
		-- TODO: make this support non-tmux mode so that I can somehow use when not in tmux
		["<leader>gg"] = { "<cmd>silent !tmux neww lazygit<cr>", desc = "Open lazygit" },
		-- TODO: I really should stop this and use Telescope and or harpoon
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
		["<leader>ll"] = {
			function()
				vim.lsp.buf.code_action({ context = { only = { 'source.addMissingImports' }, triggerKind = 1 }, apply = true })
			end,
			desc = "test null code",
		},
		["<C-p>"] = {
			function()
				vim.fn.system("tmux switch-client -p")
			end,
			desc = "Switch tmux session back",
		},
		-- open the fuzzy menu for finding projects
		["<C-f>"] = { "<cmd>silent !tmux neww tmux-sessionizer<cr>", desc = "Open tmux sessionizer" },
		-- open a new tmux window
		-- TODO: i have to figure this out
		-- ["<C-t>"] = { "<cmd>silent !tmux neww zsh<cr>", desc = "Open a new tmux window" },
		-- -- open a new tmux session
		-- BUG: this will open when pressing tab :(
		-- ["<C-i>"] = { "<cmd>silent !tmux neww new-tmux-session<cr>", desc = "Open a new tmux session" },
	},
}
