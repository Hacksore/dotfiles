return {
	-- add new user interface icon
	icons = {
		VimIcon = "",
		ScrollText = "",
		GitBranch = "",
		GitAdd = "",
		GitChange = "",
		GitDelete = "",
	},
	options = {
		opt = {
			spell = false, -- Enable spell checking
			swapfile = false, -- Disable swap files
			title = true, -- Allow nvim to update the term titlerelativenumber
			relativenumber = false, -- Disable relative line numbers
		},
	},
	updater = {
		channel = "stable",
		remote = "origin",
		version = "latest",
		brnch = "main",
	},
	lsp = {
		formatting = {
			format_on_save = {
				enabled = false, -- disable format on save
			},
		},
	},
}
