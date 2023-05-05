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
		-- set highlights for all themes
		-- use a function override to let us use lua to retrieve colors from highlight group
		-- there is no default table so we don't need to put a parameter for this function
		init = function()
			local get_hlgroup = require("astronvim.utils").get_hlgroup
			-- get highlights from highlight groups
			local normal = get_hlgroup("Normal")
			local fg, bg = normal.fg, normal.bg
			local bg_alt = get_hlgroup("Visual").bg
			local green = get_hlgroup("String").fg
			local red = get_hlgroup("Error").fg
			-- return a table of highlights for telescope based on colors gotten from highlight groups
			return {
				TelescopeBorder = { fg = bg_alt, bg = bg },
				TelescopeNormal = { bg = bg },
				TelescopePreviewBorder = { fg = bg, bg = bg },
				TelescopePreviewNormal = { bg = bg },
				TelescopePreviewTitle = { fg = bg, bg = green },
				TelescopePromptBorder = { fg = bg_alt, bg = bg_alt },
				TelescopePromptNormal = { fg = fg, bg = bg_alt },
				TelescopePromptPrefix = { fg = red, bg = bg_alt },
				TelescopePromptTitle = { fg = bg, bg = red },
				TelescopeResultsBorder = { fg = bg, bg = bg },
				TelescopeResultsNormal = { bg = bg },
				TelescopeResultsTitle = { fg = bg, bg = bg },
			}
		end,
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
