-- TODO: fix copi
-- TODO: fix spell checker

return {
	-- gives me nice highlighting for jsx
	{
		"MaxMEllon/vim-jsx-pretty",
		event = "User Astrofile",
	},
	-- add a nice tui thing for commands
	{
		"folke/noice.nvim",
		event = "User Astrofile",
		config = function()
			require("noice").setup({
				lsp = {
					hover = {
						enabled = false,
					},
					signature = {
						enabled = false,
					},
				},
			})
		end,
	},
	{
		"laytan/cloak.nvim",
		event = "user astrofile",
		config = function()
			require("cloak").setup({
				enabled = true,
				cloak_character = "*",
				-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
				highlight_group = "Comment",
				patterns = {
					{
						-- Match any file starting with ".env".
						-- This can be a table to match multiple file patterns.
						file_pattern = {
							".env*",
							"wrangler.toml",
							".dev.vars",
						},
						-- Match an equals sign and any character after it.
						-- This can also be a table of patterns to cloak,
						-- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
						cloak_pattern = "=.+",
					},
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = "User Astrofile",
	},
	-- This allows for JSX comments 
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "user astrofile",
		config = function()
			require("nvim-treesitter.configs").setup({
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})
		end,
	},
	-- add discord presence
	{
		"andweeb/presence.nvim",
		event = "User Astrofile",
	},
	-- Config the tree to shows hidden files
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		opts = {
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_by_name = {
						".git",
						".DS_Store",
					},
				},
			},
		},
	},
	{
		"tpope/vim-surround",
		event = "User Astrofile",
	},
	-- enable github copilot
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			vim.defer_fn(function()
				require("copilot").setup({
					filetypes = {
						javascript = true, -- allow specific filetype
						typescript = true, -- allow specific filetype
						["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
					},
				})
			end, 100)
		end,
	},
	-- give nice auto complete
	{
		"zbirenbaum/copilot-cmp",
		after = "copilot",
		config = function()
			require("copilot_cmp").setup({})
		end,
	},
	-- configure the status line to include the mode as well
	{
		"rebelot/heirline.nvim",
		opts = function(_, opts)
			local status = require("astronvim.utils.status")
			opts.statusline = {
				hl = { fg = "fg", bg = "bg" },
				status.component.mode({ mode_text = { padding = { left = 1, right = 1 } } }), -- add the mode text
				status.component.git_branch(),
				status.component.file_info({ filetype = {}, filename = false, file_modified = false }),
				status.component.git_diff(),
				status.component.diagnostics(),
				status.component.fill(),
				status.component.cmd_info(),
				status.component.fill(),
				status.component.lsp(),
				status.component.treesitter(),
				status.component.nav(),
			}
			return opts
		end,
	},
}
