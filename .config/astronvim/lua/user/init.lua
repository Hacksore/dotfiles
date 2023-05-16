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
			spell = true,        -- Enable spell checking
			swapfile = false,    -- Disable swap files
			title = true,        -- Allow nvim to update the term titlerelativenumber
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
		setup_handlers = {
			-- add custom handler
			denols = function(_, opts)
				require("deno-nvim").setup({ server = opts })
			end,
		},
		config = {
			denols = function(opts)
				opts.root_dir = require("lspconfig.util").root_pattern("deno.json")
				return opts
			end,
			tsserver = function(opts)
				opts.root_dir = require("lspconfig.util").root_pattern("package.json")
				opts.single_file_support = false
				return opts
			end,
		},
		formatting = {
			format_on_save = {
				enabled = false, -- disable format on save
			},
		},
	},
}
