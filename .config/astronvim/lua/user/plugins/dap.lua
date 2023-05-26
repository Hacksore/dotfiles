return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "theHamsta/nvim-dap-virtual-text", config = true },
	},
	config = function()
		local dap = require("dap")

		-- TODO: do we need to have other adapters
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "js-debug-adapter", -- As I'm using mason, this will be in the path
				args = { "${port}" },
			},
		}

		for _, language in ipairs({ "javascript" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch File",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "launch",
					name = "Attach to Process",
					proccessId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
		end

		dap.configurations["typescript"] = {
			-- NOTE: this is working but only allows you to run the current file
			-- you also need to have both ts-node and typescript installed as dev deps
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch Current File (pwa-node with ts-node)",
				cwd = vim.fn.getcwd(),
				runtimeArgs = { "--loader", "ts-node/esm" },
				runtimeExecutable = "node",
				args = { "${file}" },
				sourceMaps = true,
				protocol = "inspector",
				skipFiles = { "<node_internals>/**", "node_modules/**" },
				resolveSourceMapLocations = {
					"${workspaceFolder}/**",
					"!**/node_modules/**",
				},
			},
			-- TODO: how can I make it allow for debughing npm scripts?
			-- {
			-- 	type = "pwa-node",
			-- 	request = "launch",
			-- 	name = "Launch Current File (pwa-node with ts-node)",
			-- 	cwd = vim.fn.getcwd(),
			-- 	runtimeArgs = { "--loader", "ts-node/esm" },
			-- 	runtimeExecutable = "node",
			-- 	args = { "${file}" },
			-- 	sourceMaps = true,
			-- 	protocol = "inspector",
			-- 	skipFiles = { "<node_internals>/**", "node_modules/**" },
			-- 	resolveSourceMapLocations = {
			-- 		"${workspaceFolder}/**",
			-- 		"!**/node_modules/**",
			-- 	},
			-- },
		}
	end,
}
