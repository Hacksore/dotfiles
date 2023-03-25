return {
	-- any custom config
	options = {
		opt = {
			spell = true, -- Enable spell checking
			title = true, -- Allow nvim to update the term title
		},
	},
	updater = {
		channel = "stable",
		remote = "origin",
		version = "latest",
		branch = "main",
	},
	lsp = {
		servers = {
			"tsserver",
			"cssls",
			"yamlls",
			"rust_analyzer",
			"eslint",
			"gopls",
			"html",
			"jsonls",
			"lua_ls",
		},
		formatting = {
			format_on_save = {
				enabled = false, -- disable format on save
			},
		},
	},
}
