return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"mxsdev/nvim-dap-vscode-js",
			opts = { debugger_cmd = { "js-debug-adapter" }, adapters = { "pwa-node" } },
		},
		{ "theHamsta/nvim-dap-virtual-text", config = true },
	},
	config = function()
		local dap = require("dap")
		local port = 9229
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			-- port = "${port}",
			port = port,
			executable = {
				command = "node",
				args = {
					-- TODO: make this not hard coded?
					"/Users/hacksore/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					port,
				},
			},
		}

		local attach_node = {
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		}

		-- basic js debug
		dap.configurations.javascript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			attach_node,
		}
	end,
}
