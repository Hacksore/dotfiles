local M = {}

require("plenary.busted")

local MAX_LSP_TIMEOUT = 10000

--- Utility function to get current buffer info
--- @returns table with buffer number, file name, and filetype
--- @returns {buf: number, file: string, filetype: string}
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

--- Waits for diagnostics to be available in the given buffer
--- @param bufnr number Buffer number to monitor for diagnostics
--- @returns nil
local function wait_for_diagnostics(bufnr)
  local ready = false

  local aug = vim.api.nvim_create_augroup("WaitForDiagnostics", { clear = true })
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = aug,
    buffer = bufnr,
    callback = function()
      local diags = vim.diagnostic.get(bufnr)
      if #diags > 0 then
        ready = true
        vim.api.nvim_del_augroup_by_id(aug)
      end
    end,
  })

  vim.wait(MAX_LSP_TIMEOUT, function()
    return ready
  end, 200)
end

--- Main function to test Typescript LSP functionality
--- Validates that diagnostics are received and match expected errors
--- @returns nil
local function test_typescript_lsp()
  print("⌛ Starting typescript LSP validation...")
  local buf_info = get_buffer_info()

  wait_for_diagnostics(buf_info.buf)

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
