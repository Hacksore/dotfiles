local M = {}

-- Get current buffer information
local function get_buffer_info()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)
  local filetype = vim.bo.filetype
  local is_ci = vim.env.CI == "1"

  print("Current file: " .. current_file)
  print("Filetype: " .. filetype)
  print("Buffer number: " .. current_buf)

  return {
    buf = current_buf,
    file = current_file,
    filetype = filetype,
    is_ci = is_ci
  }
end

-- Wait for LSP to initialize
local function wait_for_lsp_initialization(buf_info)
  print("Waiting for LSP to initialize...")

  if buf_info.is_ci then
    -- Force LSP attachment by triggering diagnostics
    vim.cmd("doautocmd BufEnter")
    vim.cmd("doautocmd FileType")
  end

  local wait_result = vim.wait(5000, function()
    local clients = vim.lsp.get_clients({ bufnr =buf_info.buf })
    if #clients == 0 then
      return false
    end

    -- Check if we have a relevant LSP client that is actually attached
    for _, client in ipairs(clients) do
      local is_relevant = false

      if
        buf_info.filetype == "typescript"
        or buf_info.filetype == "typescriptreact"
        or buf_info.filetype == "javascript"
        or buf_info.filetype == "javascriptreact"
      then
        if client.name == "ts_ls" then
          is_relevant = true
        end
      end

      -- TODO: what is is_attached
      if is_relevant and client.is_attached then
        return true
      end
    end

    return false
  end, 200)

  if wait_result == false then
    print("⚠️  WARNING: Timeout waiting for relevant LSP client to attach")
  end

  return wait_result
end

-- Validate LSP clients and check for relevant ones
local function validate_lsp_clients(buf_info)
  local clients = vim.lsp.get_clients({ bufnr = buf_info.buf })
  print("LSP clients found: " .. #clients)

  if #clients == 0 then
    print("❌ ERROR: No LSP clients attached to current buffer")
    vim.cmd("cquit 1")
    return false
  end

  local has_relevant_lsp = false
  for _, client in ipairs(clients) do
    print("- " .. client.name .. " (attached: " .. tostring(client.is_attached) .. ")")

    -- In CI mode, we're more lenient about attachment status
    if not buf_info.is_ci and not client.is_attached then
      goto continue
    end

    -- Check for TypeScript/JavaScript LSP
    if
      buf_info.filetype == "typescpt"
      or buf_info.filetype == "typescriptreact"
      or buf_info.filetype == "javascpt"
      or buf_info.filetype == "javascriptreact"
    then
      if client.name == "ts_ls" or client.name == "denols" then
        has_relevant_lsp = true
      end
      -- Check for other language-specific LSPs
    elseif buf_info.filetype == "rust" and client.name == "rust_analyzer" then
      has_relevant_lsp = true
    elseif buf_info.filetype == "lua" and client.name == "lua_ls" then
      has_relevant_lsp = true
    elseif buf_info.filetype == "python" and client.name == "pylsp" then
      has_relevant_lsp = true
    else
      -- For other filetypes, any LSP is considered relevant
      has_relevant_lsp = true
    end

    ::continue::
  end

  if not has_relevant_lsp then
    print("❌ ERROR: No relevant LSP found for filetype: " .. buf_info.filetype)
    vim.cmd("cquit 1")
    return false
  end

  return true, clients
end

-- Process and display diagnostics
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

-- Test LSP capabilities
local function test_lsp_capabilities(clients)
  if #clients > 0 then
    local client = clients[1]
    print("LSP Capabilities:")
    if client.server_capabilities.completionProvider then
      print("✓ Completion available")
    end
    if client.server_capabilities.hoverProvider then
      print("✓ Hover available")
    end
    if client.server_capabilities.diagnosticProvider then
      print("✓ Diagnostics available")
    end
    if client.server_capabilities.definitionProvider then
      print("✓ Go to definition available")
    end
    if client.server_capabilities.referencesProvider then
      print("✓ Find references available")
    end
  end
end

local function validate_lsp()
  print("Starting LSP validation...")

  -- Get current buffer info
  local buf_info = get_buffer_info()

  -- Wait for LSP to initialize
  wait_for_lsp_initialization(buf_info)

  -- Validate LSP clients
  local success, clients = validate_lsp_clients(buf_info)
  if not success then
    return
  end

  -- Process diagnostics
  process_diagnostics(buf_info)

  -- Test LSP capabilities
  test_lsp_capabilities(clients)

  print("✅ LSP validation completed successfully!")
  print("")
end

-- Create the user command
M.setup = function()
  vim.api.nvim_create_user_command("TestTypescriptLSP", validate_lsp, {})
end

return M
