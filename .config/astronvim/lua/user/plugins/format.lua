return {
	"jay-babu/mason-null-ls.nvim",
	opts = {
		handlers = {
			-- TODO: this is breaking eslint maybe it is core now?
			eslint_d = function()
				local nullLs = require("null-ls")
				nullLs.register(nullLs.builtins.diagnostics.eslint_d.with({
					condition = function(utils)
						local files = { "eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.cjs" }
						return utils.root_has_file(files)
					end,
				}))
			end,
			-- for prettier
			prettier = function()
				local nullLs = require("null-ls")
				nullLs.register(nullLs.builtins.formatting.prettier.with({
					condition = function(utils)
						local files =
						{ "package.json", ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs" }
						return utils.root_has_file(files)
					end,
				}))
			end,
			-- beautysh
			beautysh = function()
				local nullLs = require("null-ls")
				nullLs.register(nullLs.builtins.formatting.beautysh.with({
					args = {
						"--indent-size",
						"2",
						"$FILENAME",
					},
				}))
			end,
		},
	},
}
