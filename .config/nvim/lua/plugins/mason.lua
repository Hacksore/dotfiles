---@type LazySpec
return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
				"bashls",
				"lua_ls",
				"cssls",
				"dockerls",
				"biome",
				"html",
				"jsonls",
				"marksman",
				"rust_analyzer",
				"ruby_lsp",
				"jdtls",
				"tailwindcss",
				"tsserver",
				"vuels",
				"astro",
				"docker_compose_language_service",
				"eslint",
				"gopls",
				"graphql",
				"prismals",
				"pylsp",
				"yamlls",
			})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
				"prettier",
				"shfmt",
			})
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
				"javascript",
			})
		end,
	},
}
