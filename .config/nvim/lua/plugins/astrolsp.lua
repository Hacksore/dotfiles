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
		mappings = {
			v = {
				-- stop making the pasted text go into my clipboard buffer
				p = {
					[["_dP]], -- this goes to narnia (aka the void)
				},
			},
			n = {
				["<leader>ff"] = { "<cmd>Telescope find_files hidden=true<cr>", desc = "Telescope find files" },
				["<leader>gg"] = { "<cmd>silent !tmux neww lazygit<cr>", desc = "Open lazygit" },
				["<leader>1"] = { "<cmd>bprevious<cr>", desc = "Switch buffer backwards" },
				["<leader>2"] = { "<cmd>bnext<cr>", desc = "Switch buffer forward" },
				["<leader>h"] = false,
				-- NOTE: this is a bunch of stuff for tmux
				["<C-n>"] = {
					function()
						vim.fn.system("tmux switch-client -n")
					end,
					desc = "Switch tmux session forward",
				},
				["<C-p>"] = {
					function()
						vim.fn.system("tmux switch-client -p")
					end,
					desc = "Switch tmux session back",
				},
				-- open the fuzzy menu for finding projects
				["<C-f>"] = { "<cmd>silent !tmux neww tmux-sessionizer<cr>", desc = "Open tmux sessionizer" },
				-- test auto import
				["<leader>ll"] = {
					function()
						vim.lsp.buf.code_action({
							context = { only = { "source.addMissingImports" }, triggerKind = 1 },
							apply = true,
						})
					end,
					desc = "test null code",
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
