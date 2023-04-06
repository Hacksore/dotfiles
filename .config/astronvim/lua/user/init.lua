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
	-- any custom config
	options = {
		g = {
			copilot_no_tab_map = true,
			copilot_assume_mapped = true,
			copilot_tab_fallback = "",
		},
		opt = {
			spell = true,  -- Enable spell checking
			swapfile = false, -- Disable swap files
			title = true,  -- Allow nvim to update the term title
		},
	},
	updater = {
		channel = "stable",
		remote = "origin",
		version = "latest",
		brnch = "main",
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
