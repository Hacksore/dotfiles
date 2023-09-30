return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "theHamsta/nvim-dap-virtual-text", config = true },
	},
	config = function()
		local dap = require("dap")

		local masonPath = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
		local jsDebugBin = masonPath .. "bin/js-debug-adapter"

		dap.adapters.chrome = {
			type = "executable",
			command = "node",
			args = {
				masonPath .. "packages/chrome-debug-adapter/out/src/chromeDebug.js",
			},
		}

		-- https://nextjs.org/docs/pages/building-your-application/configuring/debugging
		dap.adapters["node-terminal"] = {
			type = "executable",
			command = "node",
		}

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = { command = jsDebugBin, args = { "${port}" } },
		}

		local pwaNodeAttach = {
			type = "pwa-node",
			request = "launch",
			name = "js-debug: Attach to Process (pwa-node)",
			proccessId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		}

		-- debug nodejs scripts
		for _, language in ipairs({ "javascript", "javascriptreact" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "js-debug: Launch File (pwa-node)",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				pwaNodeAttach,
			}
		end

		for _, language in ipairs({ "typescript", "typescriptreact" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "typescript debug: Launch Current File (tsx)",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "node",
					runtimeArgs = { "--loader", "tsx" },
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
					resolveSourceMapLocations = {
						"${workspaceFolder}/dist/**/*.js",
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
				},
				pwaNodeAttach,
			}
		end
	end,
}
