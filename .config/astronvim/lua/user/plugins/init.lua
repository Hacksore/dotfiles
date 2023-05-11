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
	-- vim doge for nice JSDocs
	{
		"kkoomen/vim-doge",
		event = "User Astrofile",
	},
	-- this allows for JSX comments
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "User Astrofile",
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
	-- this gives nice motions around things
	{
		"tpope/vim-surround",
		event = "User Astrofile",
	},
	-- disable the movement and make the toasts compact
	{
		"nvim-notify",
		opts = { stages = "fade", render = "compact" },
		enabled = false,
	},
	-- add plugin for todo highlighting
	-- TODO: testing this thing
	{
		"folke/todo-comments.nvim",
		event = "User Astrofile",
		config = function()
			require("todo-comments").setup({})
		end,
	},
}
