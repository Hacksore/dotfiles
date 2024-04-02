---@type LazySpec
return {
	"AstroNvim/astroui",
	---@type AstroUIOpts
	opts = {
		-- change colorscheme
		colorscheme = "astrodark",
		-- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
		highlights = {
			init = { -- this table overrides highlights in all themes
				-- Normal = { bg = "#000000" },
			},
			astrotheme = { -- a table of overrides/changes when applying the astrotheme theme
				-- Normal = { bg = "#000000" },
			},
		},
		icons = {
			VimIcon = "",
			ScrollText = "",
			GitBranch = "",
			GitAdd = "",
			GitChange = "",
			GitDelete = "",
			LSPLoading1 = "⠋",
			LSPLoading2 = "⠙",
			LSPLoading3 = "⠹",
			LSPLoading4 = "⠸",
			LSPLoading5 = "⠼",
			LSPLoading6 = "⠴",
			LSPLoading7 = "⠦",
			LSPLoading8 = "⠧",
			LSPLoading9 = "⠇",
			LSPLoading10 = "⠏",
		},
	},
}
