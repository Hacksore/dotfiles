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
	-- modify variables used by heirline but not defined in the setup call directly
	heirline = {
		-- define the separators between each section
		separators = {
			left = { "", " " }, -- separator for the left side of the statusline
			right = { " ", "" }, -- separator for the right side of the statusline
			tab = { "", "" },
		},
		-- add new colors that can be used by heirline
		colors = function(hl)
			local get_hlgroup = require("astronvim.utils").get_hlgroup
			-- use helper function to get highlight group properties
			local comment_fg = get_hlgroup("Comment").fg
			hl.git_branch_fg = comment_fg
			hl.git_added = comment_fg
			hl.git_changed = comment_fg
			hl.git_removed = comment_fg
			hl.blank_bg = get_hlgroup("Folded").fg
			hl.file_info_bg = get_hlgroup("Visual").bg
			hl.nav_icon_bg = get_hlgroup("String").fg
			hl.nav_fg = hl.nav_icon_bg
			hl.folder_icon_bg = get_hlgroup("Error").fg
			return hl
		end,
		attributes = {
			mode = { bold = true },
		},
		icon_highlights = {
			file_icon = {
				statusline = false,
			},
		},
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
