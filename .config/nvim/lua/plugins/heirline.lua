return {
	"rebelot/heirline.nvim",
	opts = function(_, opts)
		local status = require("astroui.status")

		opts.statusline = {
			hl = { fg = "fg", bg = "bg" },
			status.component.mode({
				mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } }, padding = { right = 1 } },
			}),
			status.component.git_branch(),
			status.component.file_info({ filetype = {}, filename = false, file_modified = false }),
			status.component.git_diff(),
			status.component.diagnostics(),
			status.component.fill(),
			status.component.cmd_info(),
			status.component.fill(),
			status.component.lsp(),
			status.component.treesitter(),
			status.component.nav(),
		}
	end,
}
