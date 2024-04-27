return {
	"goolord/alpha-nvim",
	opts = function(_, opts)
		-- customize the dashboard header
		opts.section.header.val = {
			"    ███    ██ ██    ██ ██ ███    ███",
			"    ████   ██ ██    ██ ██ ████  ████",
			"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
			"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
			"    ██   ████   ████   ██ ██      ██",
		}

		opts.section.header.opts.hl = "DashboardHeader"

		opts.section.buttons.val = {
			opts.button("LDR S l", "  Last Session  "),
			opts.button("LDR n", "  New File  "),
			opts.button("LDR f f", "  Find File  "),
			opts.button("LDR f o", "󰈙  Recents  "),
			opts.button("LDR f w", "󰈭  Find Word  "),
		}

		opts.config.layout[1].val = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) })
		opts.config.layout[3].val = 5
		opts.config.opts.noautocmd = true

		return opts
	end,
}
