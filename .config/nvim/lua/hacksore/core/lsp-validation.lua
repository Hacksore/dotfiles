local M = {}

require("plenary.busted")

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

local MAX_LSP_TIMEOUT = 10000

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
  return ready
end

local function test_typescript_lsp()
  print("⌛ Starting typescript LSP validation...")

  -- Get current buffer info
  local buf_info = get_buffer_info()

  -- Wait for LSP to initialize
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

  -- TODO: would be nice to have some fn to do expectd instead of assert, in case for some reason the
  -- error message changes slightly in the future
  assert.is_equal(diagnostics[1].message, "Type 'number' is not assignable to type 'string'.")

  print("✅ LSP validation completed successfully!\n")
end

M.setup = function()
  vim.api.nvim_create_user_command("TestTypescriptLSP", test_typescript_lsp, {})

  -- TODO: in the future we could add more commands to test other LSPs
end

return M
