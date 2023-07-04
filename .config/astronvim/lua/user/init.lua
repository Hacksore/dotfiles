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
	highlights = {
		init = function()
			local utils = require("user.utils")
			local red = 0xe06c75
			local green = 0x04260f

			return {
				DiffAdd = { bg = utils.dim(green) },
				DiffDelete = { bg = utils.dim(red) },
			}
		end,
	},
	options = {
		opt = {
			spell = true,        -- Enable spell checking
			swapfile = false,    -- Disable swap files
			title = true,        -- Allow nvim to update the term titlerelativenumber
			relativenumber = false, -- Disable relative line numbers
		},
	},
	lsp = {
		formatting = {
			timeout_ms = 5000,
			format_on_save = {
				enabled = false, -- disable format on save
			},
		},
	},
	updater = {
		channel = "stable",
	},
}
