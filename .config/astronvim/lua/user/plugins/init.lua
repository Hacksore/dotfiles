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
	-- TODO: i need to learn how to use this
	{
		"kkoomen/vim-doge",
		event = "VeryLazy",
		build = ':call doge#install()'
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
	-- disable this plug
	{
		"aerial.nvim",
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
		tag = "v1.7.0",
	},
	{
		"lrincejoogie/tailwind-highlight.nvim",
	}
}
