return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		-- event = "InsertEnter",
		config = function()
			vim.notify("Setting up copilot", vim.log.levels.INFO)
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 150,
					keymap = {
						-- Nice key to accept so it wont interfere with autocomplete
						accept = "<C-j>",
						-- Nice to dismiss it
						dismiss = "<C-k>",
					},
				},
			})
		end,
	},
}
