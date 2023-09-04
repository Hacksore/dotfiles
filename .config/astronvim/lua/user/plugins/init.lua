return {
	-- gives me nice highlighting for jsx
	{
		"MaxMEllon/vim-jsx-pretty",
		event = "User Astrofile",
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
	},
	-- vim doge for nice JSDocs
	{
		"kkoomen/vim-doge",
		event = "VeryLazy",
		build = ':call doge#install()'
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
	-- add plugin for todo highlighting
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		opts = {}
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		opts = {
			defaults = {
				hidden = true,
				file_ignore_patterns = {
					"%.git/",
					"node_modules/",
					"coverage/",
					"__pycache__/",
					"%.o",
					"client/graphql/",
					"**/generatedTypesAndHooks.ts",
				},
			}
		}
	},
	{
		"AstroNvim/astrotheme",
		-- pinning this to a specific tag to preserve the old colorscheme
		-- tag = "v1.7.0"
	},
	-- add tw highlight for colors
	{
		"princejoogie/tailwind-highlight.nvim",
	},
}
