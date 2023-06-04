-- Why is this not built into nvim lol
function find_index(value, tbl)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return nil
end

-- TODO: it's a bit scuffed but it works
local function switch_tmux_session(direction)
	local current_session = vim.fn.systemlist("tmux display-message -p '#S'")[1]
	local sessions = vim.fn.systemlist("tmux list-sessions -F '#S'")

	local current_session_index = find_index(current_session, sessions)
	local next_session_index = current_session_index + direction
	if next_session_index > #sessions then
		next_session_index = 1
	end

	local new_tmux_index = sessions[next_session_index]
	-- switch to the index of the session
	vim.fn.system("tmux switch-client -t " .. new_tmux_index)
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
	},
}
