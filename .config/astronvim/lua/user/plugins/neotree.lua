-- tweaks for neo-tree
return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	opts = {
		event_handlers = {
			{
				event = "file_opened",
				handler = function(file_path)
					-- auto close
					-- vimc.cmd("Neotree close")
					-- OR
					require("neo-tree.command").execute({ action = "close" })
				end
			},
		},
		window = { position = "right", width = 100 },
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = true,
				never_show = {
					".git",
					".DS_Store",
				},
			},
		},
		source_selector = {
			winbar = false,
		},
	},
}
