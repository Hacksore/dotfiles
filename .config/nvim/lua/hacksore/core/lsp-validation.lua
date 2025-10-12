local M = {}

-- TODO: this is cracked but should i used busted instead
local assert = require("luassert")

local function get_buffer_info()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)
  local filetype = vim.bo.filetype

  return {
    buf = current_buf,
    file = current_file,
    filetype = filetype,
  }
end

local function wait_for_lsp_initialization(buf_info)
  vim.cmd("doautocmd BufEnter")
  vim.cmd("doautocmd FileType")

  vim.wait(5000, function()
    local clients = vim.lsp.get_clients({ bufnr = buf_info.buf })
    if #clients == 0 then
      return false
    end

    for _, client in ipairs(clients) do
      -- TODO: this `is_attached` property seems undocumented and not sure if i should be using it 😂
      if client.name == "ts_ls" and client.is_attached then
        return true
      end
    end

    return false
  end, 200)
end

local function test_typescript_lsp()
  print("⌛ Starting typescript LSP validation...")

  -- Get current buffer info
  local buf_info = get_buffer_info()

  -- Wait for LSP to initialize
  wait_for_lsp_initialization(buf_info)

  print("🫡 Typescript LSP ready...")

  local diagnostics = vim.diagnostic.get(buf_info.buf)
  if #diagnostics == 0 then
    print("❌ ERROR: No diagnostics found. LSP might not be working correctly.")
    vim.cmd("cquit 1")
    return
  end

  print("📊 Typescript diagnostics found: " .. #diagnostics)
  for id, diag in ipairs(diagnostics) do
    print("  [" .. id .. "] " .. diag.message)
  end

  -- TODO: would be nice to have some fn to do expectd instead of assert, in case for some reason the
  -- error message changes slightly in the future
  assert.is_equal(diagnostics[1].message, "Type 'number' not assignable to type 'string'.")

  print("✅ LSP validation completed successfully!\n")
end

M.setup = function()
  vim.api.nvim_create_user_command("TestTypescriptLSP", test_typescript_lsp, {})

  -- TODO: in the future we could add more commands to test other LSPs
end

return M
