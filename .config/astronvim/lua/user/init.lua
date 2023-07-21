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
		config = {
			tailwindcss = {
				on_attach = function(client, bufnr)
					local tw_highlight = require("tailwind-highlight")
					print("on attach for tw")

					tw_highlight.setup(client, bufnr, {
						single_column = false,
						mode = "background",
						debounce = 200,
					})
				end
			}

		}
	},
	updater = {
		channel = "stable",
	},
	colorscheme = "astrotheme"
}
