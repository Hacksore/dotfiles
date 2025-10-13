local M = {}

local util = require("hacksore.utils.test.lsp")
require("plenary.busted")

--- Main function to test Typescript LSP functionality
--- Validates that diagnostics are received and match expected errors
--- @returns nil
local function test_typescript_lsp()
  print("⌛ Starting typescript LSP validation...")
  local buf_info = util.get_buffer_info()

  util.wait_for_diagnostics(buf_info.buf, util.TYPESCRIPT_CLIENT_NAME)

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

  assert.is_equal(diagnostics[1].message, "Type 'number' is not assignable to type 'string'.")

  print("✅ LSP validation completed successfully!\n")
end

--- Sets up the user command to trigger the Typescript LSP test
--- @returns nil
M.setup = function()
  vim.api.nvim_create_user_command("TestTypescriptLSP", test_typescript_lsp, {})

  -- TODO: in the future we could add more commands to test other LSPs
end

return M
