return {
	-- enable github copilot tab completion with a community plugin
	{ import = "astrocommunity.completion.copilot-lua-cmp" },
	-- TODO: can this work to get autocomplete for copilot working in completion
	{
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup({})
		end,
	},
}
