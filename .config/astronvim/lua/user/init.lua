return {
	polish = function()
		-- fix comment plugin
		require("nvim-treesitter.configs").setup({
			context_commentstring = {
				enable = true,
			},
		})

		local titleFix = vim.api.nvim_create_augroup("titlefix", { clear = true })
		vim.api.nvim_create_autocmd("BufEnter", {
			desc = "Test to mutate the title",
			group = titleFix,
			callback = function(options)
				local buffNumber = options.buf
				local fileType = vim.bo[buffNumber].filetype

				if fileType == "neo-tree" then
					vim.opt.titlestring = "[In Tree]"
				else
					vim.opt.titlestring = "%f"
				end
			end,
		})
	end,
	-- any custom config
	options = {
		g = {
			copilot_no_tab_map = true,
			copilot_assume_mapped = true,
			copilot_tab_fallback = "",
		},
		opt = {
			spell = true,  -- Enable spell checking
			swapfile = false, -- Disble swap files
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
