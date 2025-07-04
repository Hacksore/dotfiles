local M = {}

-- Helper function to parse rustfmt.toml and extract tab_spaces
function M.parse_rustfmt_toml(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end
  local content = file:read("*all")
  file:close()
  local tab_spaces = content:match("tab_spaces%s*=%s*(%d+)")
  return tab_spaces and tonumber(tab_spaces) or nil
end

-- Helper function to find the closest rustfmt.toml file
function M.find_rustfmt_toml(start_path)
  local path = start_path
  while path ~= "/" do
    local rustfmt_path = path .. "/rustfmt.toml"
    local file = io.open(rustfmt_path, "r")
    if file then
      file:close()
      return rustfmt_path
    end
    path = path:match("(.*)/[^/]*$") or "/"
  end
  return nil
end

return M

