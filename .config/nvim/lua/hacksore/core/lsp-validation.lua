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
      -- TODO: this property seems undocumented
      if client.name == "ts_ls" and client.is_attached then
        return true
      end
    end

    return false
  end, 200)
end

local function validate_lsp_clients(buf_info)
  local clients = vim.lsp.get_clients({ bufnr = buf_info.buf })

  if #clients == 0 then
    print("❌ ERROR: No LSP clients attached to current buffer")
    vim.cmd("cquit 1")
    return false
  end

  local has_relevant_lsp = false

  for _, client in ipairs(clients) do
    if client.name == "ts_ls" then
      has_relevant_lsp = true
    end
  end

  if not has_relevant_lsp then
    print("❌ ERROR: No relevant LSP found for filetype: " .. buf_info.filetype)
    vim.cmd("cquit 1")
    return false
  end

  return true, clients
end

local function process_diagnostics(buf_info)
  local diagnostics = vim.diagnostic.get(buf_info.buf)
  print("Diagnostics found: " .. #diagnostics)

  for _, diag in ipairs(diagnostics) do
    local severity = "INFO"
    if diag.severity == vim.diagnostic.severity.ERROR then
      severity = "ERROR"
    elseif diag.severity == vim.diagnostic.severity.WARN then
      severity = "WARN"
    elseif diag.severity == vim.diagnostic.severity.HINT then
      severity = "HINT"
    end
    print("- Line " .. (diag.lnum + 1) .. " [" .. severity .. "]: " .. diag.message)
  end
end

local function validate_lsp()
  print("⌛ Starting LSP validation...")

  -- Get current buffer info
  local buf_info = get_buffer_info()

  -- Wait for LSP to initialize
  wait_for_lsp_initialization(buf_info)

  -- Validate LSP clients
  local success = validate_lsp_clients(buf_info)
  if not success then
    return
  end

  -- Process diagnostics
  process_diagnostics(buf_info)

  print("✅ LSP validation completed successfully!")
  print("")
end

-- Create the user command
M.setup = function()
  vim.api.nvim_create_user_command("TestTypescriptLSP", validate_lsp, {})
end

return M
