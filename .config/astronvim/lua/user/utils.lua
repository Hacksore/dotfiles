local M = {}

-- Find the index of a given value in a table
function M.find_index(value, tbl)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return nil
end

return M
