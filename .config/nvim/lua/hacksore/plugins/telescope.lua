return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				file_ignore_patterns = { "node_modules", ".git" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<Leader>ff", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Telescope find files" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<Leader>fw", function()
			require("telescope.builtin").live_grep()
		end, { desc = "Find words" })
		keymap.set("n", "<Leader>fW", function()
			require("telescope.builtin").live_grep({
				additional_args = function(args)
					return vim.list_extend(args, { "--hidden", "--no-ignore" })
				end,
			})
		end, { desc = "Find words in all files" })
	end,
}
