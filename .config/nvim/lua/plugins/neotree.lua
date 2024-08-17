-- tweaks for neo-tree
return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	opts = {
		event_handlers = {
			{
				event = "file_opened",
				handler = function()
					-- auto close
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
		},
		window = { position = "right", width = 100 },
		filesystem = {
			window = {
				mappings = {
					["<C-f>"] = "<cmd>silent !tmux neww tmux-sessionizer<cr>"
				},
			},
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = true,
				never_show = {
					".git",
					".DS_Store",
				},
			},
			components = {
				name = function(config, node, state)
					local components = require("neo-tree.sources.common.components")
					local name = components.name(config, node, state)
					if node:get_depth() == 1 then
						name.text = vim.fn.pathshorten(name.text, 2)
					end
					return name
				end,
			},
		},
		source_selector = {
			winbar = false,
		},
	},
}
