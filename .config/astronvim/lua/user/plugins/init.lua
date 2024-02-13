return {

	{
		"creativenull/dotfyle-metadata.nvim",
		config = function()
			local augroup = vim.api.nvim_create_augroup("DotfyleMetadataGroup", {})
			vim.api.nvim_create_autocmd("User", {
				group = augroup,
				pattern = { "LazyUpdate", "LazyInstall", "LazySync", "LazyClean" },
				once = true,
				callback = function()
					local dotfyle_metadata = require("dotfyle_metadata")
					dotfyle_metadata.generate({})
					local home = vim.fn.getenv("HOME")
					vim.cmd("!npx prettier --write " .. dotfyle_metadata.dotfyle_path)
					local move_dir_string = string.format("!mv %s %s", dotfyle_metadata.dotfyle_path,
						home .. "/.config/astronvim/lua/user")
					vim.cmd(move_dir_string)
				end,
			})
		end,
		event = "VeryLazy",
	},
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
		opts = {
			keywords = {
				BLOCKER = { icon = " ", color = "error" },
			},
			colors = {
				hint = { "#10B981" },
			}
		}
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
	-- add tw highlight for colors
	{
		"princejoogie/tailwind-highlight.nvim",
	},
}
