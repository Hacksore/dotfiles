return {
	n = {
		["<leader>ff"] = { "<cmd>Telescope git_files<cr>", desc = "Telescope git files" },
		["<leader>1"] = { "<cmd>bprevious<cr>", desc = "Switch buffer backwards" },
		["<leader>2"] = { "<cmd>bnext<cr>", desc = "Switch buffer forward" },
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
		-- unbind control+t
		["<C-t>"] = { "<cmd>silent !tmux neww new_tmux_session<cr>", desc = "Open an new tmux session" },
	},
}
