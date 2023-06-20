-- tweaks for neo-tree
return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	opts = {
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
