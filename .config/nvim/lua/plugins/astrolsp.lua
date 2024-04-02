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
			timeout_ms = 1000, -- default format timeout
			-- filter = function(client) -- fully override the default formatting function
			--   return true
			-- end
		},
		-- Configure buffer local auto commands to add when attaching a language server
		autocmds = {
			-- first key is the `augroup` to add the auto commands to (:h augroup)
			lsp_document_highlight = {
				-- Optional condition to create/delete auto command group
				-- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
				-- condition will be resolved for each client on each execution and if it ever fails for all clients,
				-- the auto commands will be deleted for that buffer
				cond = "textDocument/documentHighlight",
				-- cond = function(client, bufnr) return client.name == "lua_ls" end,
				-- list of auto commands to set
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
		-- mappings to be set up on attaching of a language server
		mappings = {},
		-- A custom `on_attach` function to be run after the default `on_attach` function
		-- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
		on_attach = function(client, bufnr)
			-- this would disable semanticTokensProvider for all clients
			-- client.server_capabilities.semanticTokensProvider = nil
		end,
	},
}
