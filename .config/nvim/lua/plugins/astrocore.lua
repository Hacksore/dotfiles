---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- Configure core features of AstroNvim
		features = {
			large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
			autopairs = true,                              -- enable autopairs at start
			cmp = true,                                    -- enable completion at start
			notifications = false,                         -- enable notifications at start
		},
		-- vim options can be configured here
		options = {
			opt = {     -- vim.opt.<key>
				spell = true, -- Enable spell checking
				wrap = true,
				spellfile = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add"),
				shiftwidth = 2,
				swapfile = false,   -- Disable swap files
				title = true,       -- Allow nvim to update the term title
				relativenumber = false, -- Disable relative line numbers
			},
		},
		mappings = {
			v = {
				-- stop making the pasted text go into my clipboard buffer
				p = {
					[["_dP]], -- this goes to narnia (aka the void)
				},
			},
			t = {
				["<C-j>"] = function()
					handle_toggleterm_suggestion_accept()
				end,
			},
			n = {
				["<Leader>ff"] = { "<cmd>Telescope find_files hidden=true<cr>", desc = "Telescope find files" },
				["<Leader>gg"] = { "<cmd>silent !tmux neww lazygit<cr>", desc = "Open lazygit" },
				["<Leader>1"] = { "<cmd>bprevious<cr>", desc = "Switch buffer backwards" },
				["<Leader>2"] = { "<cmd>bnext<cr>", desc = "Switch buffer forward" },
				["<Leader>h"] = false,
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
				["<Leader>ll"] = {
					function()
						vim.lsp.buf.code_action({
							context = { only = { "source.addMissingImports" }, triggerKind = 1 },
							apply = true,
						})
					end,
					desc = "test null code",
				},
			},
		},
	},
}
