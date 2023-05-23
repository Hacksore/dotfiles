return {
	-- gives me nice highlighting for jsx
	{
		"MaxMEllon/vim-jsx-pretty",
		event = "User Astrofile",
	},
	-- add a nice tui thing for commands
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("noice").setup({
				messages = { view_search = false },
				views = {
					cmdline_popup = {
						position = {
							row = 4,
							col = "50%",
						},
					},
				},
				routes = {
					{ filter = { event = "msg_show", find = "%d+L,%s%d+B" },        opts = { skip = true } }, -- skip save notifications
					{ filter = { event = "msg_show", find = "^%d+ more lines$" },   opts = { skip = true } }, -- skip paste notifications
					{ filter = { event = "msg_show", find = "^%d+ fewer lines$" },  opts = { skip = true } }, -- skip delete notifications
					{ filter = { event = "msg_show", find = "^%d+ lines yanked$" }, opts = { skip = true } }, -- skip yank notifications
				},
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
	{
		"folke/todo-comments.nvim",
		event = "User Astrofile",
		config = function()
			require("todo-comments").setup({})
		end,
	}
}
