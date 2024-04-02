return {
	"nvim-telescope/telescope.nvim",
	opts = {
		pickers = {
			find_files = {
				additional_args = function()
					return { "--hidden" }
				end,
			},
			live_grep = {},
		},
	},
}
