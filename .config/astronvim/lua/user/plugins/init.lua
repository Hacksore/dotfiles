return {
	-- gives me nice highlighting for jsx
	{
		"MaxMEllon/vim-jsx-pretty",
		event = "User Astrofile",
	},
	-- vim doge for nice JSDocs
	-- TODO: i need to learn how to use this
	{
		"kkoomen/vim-doge",
		event = "VeryLazy",
	},
	-- this allows for JSX comments
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "VeryLazy",
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
		event = "VeryLazy",
	},
	-- this gives nice motions around things
	{
		"tpope/vim-surround",
		event = "VeryLazy",
	},
	-- disable this plug
	{
		"nvim-notify",
		enabled = false,
	},
	-- add plugin for todo highlighting
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		config = function()
			require("todo-comments").setup({})
		end,
	},
	-- {
	-- 	dir = "~/code/opensource/astrotheme",
	-- 	lazy = false
	-- },
}
