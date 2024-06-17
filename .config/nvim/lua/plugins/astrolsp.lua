---@type LazySpec
return {
	"AstroNvim/astrolsp",
	---@type AstroLSPOpts
	opts = {
		features = {
			autoformat = false,
			codelens = true,
			inlay_hints = false,
			semantic_tokens = true,
		},
		formatting = {
			format_on_save = {
				enabled = false,
			},
			timeout_ms = 30000,
		},
		---@diagnostic disable-next-line: missing-fields
		config = {
			---@diagnostic disable-next-line: missing-fields
			tailwindcss = {
				enabled = true,
				on_attach = function(client, bufnr)
					local tw_highlight = require("tailwind-highlight")
					tw_highlight.setup(client, bufnr, {
						single_column = false,
						mode = "background",
						debounce = 200,
					})
				end,
			},
		},
	},
}
