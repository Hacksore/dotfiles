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

function M.merge(c1, c2, ratio)
  ratio = ratio or 0.5
  assert(ratio <= 1 and ratio >= 0)
  local r1 = bit.arshift(bit.band(c1, 0xFF0000), 16)
  local r2 = bit.arshift(bit.band(c2, 0xFF0000), 16)
  local g1 = bit.arshift(bit.band(c1, 0x00FF00), 8)
  local g2 = bit.arshift(bit.band(c2, 0x00FF00), 8)
  local b1 = bit.band(c1, 0x0000FF)
  local b2 = bit.band(c2, 0x0000FF)

  local r = bit.band((r1 * ratio) + (r2 * (1 - ratio)), 0xFF)
  local g = bit.band((g1 * ratio) + (g2 * (1 - ratio)), 0xFF)
  local b = bit.band((b1 * ratio) + (b2 * (1 - ratio)), 0xFF)

  return bit.lshift(r, 16) + bit.lshift(g, 8) + b
end

function M.dim(c, ratio) return M.merge(c, 0x0d1117, ratio) end

return M
