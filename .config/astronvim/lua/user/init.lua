local function add_missing_imports()
	vim.api.nvim_create_user_command('TSAddMissingImports', function()
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				only = { "source.addMissingImports" }
			}
		})
	end, {})
end

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
	polish = function()
		-- TODO:: this should work better but now it takes npm packages first then aliases
		add_missing_imports()
	end,
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
			spell = true, -- Enable spell checking
			wrap = true,
			spellfile = vim.fn.expand("~/.config/astronvim/spell/en.utf-8.add"),
			swapfile = false,    -- Disable swap files
			title = true,        -- Allow nvim to update the term title
			relativenumber = false, -- Disable relative line numbers
		},
	},
	lsp = {
		formatting = {
			format_on_save = {
				enabled = false, -- disable format on save
			},
		},
		config = {
			-- highlight tailwind classes
			tailwindcss = {
				on_attach = function(client, bufnr)
					local tw_highlight = require("tailwind-highlight")
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
	colorscheme = "astrodark",
}
