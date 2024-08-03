return {
	"hrsh7th/nvim-cmp",
	dependencies = { "zbirenbaum/copilot.lua" },
	opts = function(_, opts)
		local cmp, copilot = require("cmp"), require("copilot.suggestion")

		if not opts.mapping then
			opts.mapping = {}
		end

		opts.mapping["<C-J>"] = cmp.mapping(function()
			if copilot.is_visible() then
				copilot.accept()
			end
    end, { "i", "s" })

		opts.mapping["<C-K>"] = cmp.mapping(function()
			if copilot.is_visible() then
				copilot.dismiss()
			end
		end)

		-- make the first item selected by default
		opts.completion = {
			completeopt = "menu,menuone,noinsert",
		}

		return opts
	end,
}
