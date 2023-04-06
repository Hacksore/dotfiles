return {
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
}
