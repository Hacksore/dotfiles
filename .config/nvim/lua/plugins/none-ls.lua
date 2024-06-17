---@type LazySpec
return {
	"nvimtools/none-ls.nvim",
	opts = function(_, config)
		-- config variable is the default configuration table for the setup function call
		local null_ls = require "null-ls"

		-- Check supported formatters and linters
		-- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		config.sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.prettier,
			-- yaml formatting 🥳
			null_ls.builtins.formatting.yamlfmt,
		}
		return config -- return final config table
	end,
}
