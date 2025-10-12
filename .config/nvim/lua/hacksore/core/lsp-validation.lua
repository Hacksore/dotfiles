local M = {}

-- Get current buffer information
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

-- Wait for LSP to initialize
local function wait_for_lsp_initialization(buf_info)
  print("Waiting for LSP to initialize...")

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

local function validate_lsp()
  print("⌛ Starting LSP validation...")

  -- Get current buffer info
  local buf_info = get_buffer_info()

  -- Wait for LSP to initialize
  wait_for_lsp_initialization(buf_info)

  local diagnostics = vim.diagnostic.get(buf_info.buf)
  if #diagnostics == 0 then
    print("❌ ERROR: No diagnostics found. LSP might not be working correctly.")
    vim.cmd("cquit 1")
    return
  end

  print("diagnostics found: " .. #diagnostics)
  for _, diag in ipairs(diagnostics) do
    print(string.format(" - [%s] %s", diag.severity, diag.message))
  end

  print("✅ LSP validation completed successfully!")
  print("")
end

-- Create the user command
M.setup = function()
  vim.api.nvim_create_user_command("TestTypescriptLSP", validate_lsp, {})
end

return M
