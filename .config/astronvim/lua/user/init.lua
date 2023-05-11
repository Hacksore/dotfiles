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
			spell = true, -- Enable spell checking
			swapfile = false, -- Disable swap files
			title = true, -- Allow nvim to update the term titlerelativenumber
			relativenumber = false, -- Diable relative line numbers
		},
	},
	updater = {
		channel = "stable",
		remote = "origin",
		version = "latest",
		brnch = "main",
	},
	lsp = {
		-- TODO: i need to make this load all the mason and treesitter goodies so I don't have
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
