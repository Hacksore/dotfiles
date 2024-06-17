---@type LazySpec
return {
	-- use mason-lspconfig to configure LSP installations
	{
		"williamboman/mason-lspconfig.nvim",
		-- overrides `require("mason-lspconfig").setup(...)`
		opts = function(_, opts)
			-- add more things to the ensure_installed table protecting against community packs modifying it
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
				"bashls",
				"lua_ls",
				"cssls",
				"dockerls",
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
	-- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
	{
		"jay-babu/mason-null-ls.nvim",
		-- overrides `require("mason-null-ls").setup(...)`
		opts = function(_, opts)
			-- add more things to the ensure_installed table protecting against community packs modifying it
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
				"prettier",
				"yamlfmt",
				"shfmt",
			})
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		-- overrides `require("mason-nvim-dap").setup(...)`
		opts = function(_, opts)
			-- add more things to the ensure_installed table protecting against community packs modifying it
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
				"javascript",
			})
		end,
	},
}
