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
			timeout_ms = 1000
		},
		autocmds = {
			lsp_document_highlight = {
				cond = "textDocument/documentHighlight",
				{
					-- events to trigger
					event = { "CursorHold", "CursorHoldI" },
					-- the rest of the autocmd options (:h nvim_create_autocmd)
					desc = "Document Highlighting",
					callback = function()
						vim.lsp.buf.document_highlight()
					end,
				},
				{
					event = { "CursorMoved", "CursorMovedI", "BufLeave" },
					desc = "Document Highlighting Clear",
					callback = function()
						vim.lsp.buf.clear_references()
					end,
				},
			},
		},
		on_attach = function(client, bufnr)
			-- only do when tailwind lsp attached
			if client.name == "tailwindcss" then
				local tw_highlight = require("tailwind-highlight")
				tw_highlight.setup(client, bufnr, {
					single_column = false,
					mode = "background",
					debounce = 200,
				})
			end
		end,
	},
}
