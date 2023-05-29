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

		-- This is what vscode uses and i cant get it working yet
		-- https://nextjs.org/docs/pages/building-your-application/configuring/debugging
		dap.adapters["node-terminal"] = {
			type = "executable",
			command = "node",
			-- args = { testP },
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

		local function typescript(args)
			return {
				type = "pwa-node",
				request = "launch",
				name = ("js-debug: Launch Current File (ts-node%s)"):format(
					args and (" " .. table.concat(args, " ")) or ""
				),
				program = "${file}",
				cwd = "${workspaceFolder}",
				runtimeExecutable = "ts-node",
				runtimeArgs = args,
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
				resolveSourceMapLocations = {
					"${workspaceFolder}/dist/**/*.js",
					"${workspaceFolder}/**",
					"!**/node_modules/**",
				},
			}
		end

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
				typescript(),
				typescript({ "--esm" }),
				-- NOTE: testing the nodejs debug setup and works for API and initial SSR
				{
					type = "pwa-node",
					name = "Next.js: debug server",
					request = "launch",
					program = "${workspaceFolder}/node_modules/next/dist/bin/next",
					args = { "dev" },
					sourceMaps = true,
					cwd = "${workspaceFolder}",
					runtimeArgs = { "--inspect" },
					skipFiles = { "${workspaceFolder}/node_modules/**/*.js", "<node_internals>/**/*.js" },
					console = "integratedTerminal",
					protocol = "inspector",
				},
				{
					type = "pwa-node",
					name = "debug: npm start",
					request = "launch",
					program = "npm",
					args = { "start" },
					cwd = "${workspaceFolder}",
					runtimeArgs = { "--inspect" },
					skipFiles = { "${workspaceFolder}/node_modules/**/*.js", "<node_internals>/**/*.js" },
					console = "integratedTerminal",
					protocol = "inspector",
				},
				{
					name = "Next.Js: debug client",
					type = "chrome",
					request = "launch",
					url = "http://localhost:3000",
					webRoot = "${workspaceFolder}",
					runtimeExecutable = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
					userDataDir = "/tmp/chrome-dev",
				},
				pwaNodeAttach,
			}
		end
	end,
}
