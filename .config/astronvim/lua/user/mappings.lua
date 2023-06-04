local utils = require("user.utils")

-- TODO: it's a bit scuffed but it works
local function switch_tmux_session(direction)
	local current_session = vim.fn.systemlist("tmux display-message -p '#S'")[1]
	local sessions = vim.fn.systemlist("tmux list-sessions -F '#S'")

	local current_session_index = utils.find_index(current_session, sessions)
	local next_session_index = current_session_index + direction

	-- handle overflow
	if next_session_index > #sessions then
		next_session_index = 1
	end

	-- handle underflow
	if next_session_index < 1 then
		next_session_index = #sessions
	end

	local new_tmux_index = sessions[next_session_index]
	local command_to_switch = string.format("tmux switch-client -t %s", new_tmux_index)
	vim.fn.system(command_to_switch)
end

return {
	n = {
		["<leader>ff"] = { "<cmd>Telescope git_files<cr>", desc = "Telescope git files" },
		["<leader>1"] = { "<cmd>bprevious<cr>", desc = "Switch buffer backwards" },
		["<leader>2"] = { "<cmd>bnext<cr>", desc = "Switch buffer forward" },
		-- NOTE: this is a bunch of stuff for tmux
		["<C-n>"] = {
			function()
				switch_tmux_session(1)
			end,
			desc = "Switch tmux session forward",
		},
		["<C-p>"] = {
			function()
				switch_tmux_session(-1)
			end,
			desc = "Switch tmux session back",
		},
		-- unbind control+f
		["<C-f>"] = {
			function()
			end,
		},
	},
}
