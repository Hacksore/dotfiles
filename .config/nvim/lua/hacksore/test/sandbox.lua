-- Function to test TypeScript LSP attachment and diagnostics
local function TestTypeScriptLSP()
  -- Create a temporary TypeScript file with intentional errors
  local test_file = os.tmpname() .. '.ts'
  local file = io.open(test_file, 'w')
  if (not file) then
    print("Error: Unable to create test file")
    return
  end

  file:write([[
    // File with intentional TypeScript errors
    const x: number = "string";  // Type mismatch
    const y;                     // Missing type annotation
    console.log(undefinedVar);   // Undefined variable
  ]])
  file:close()

  -- Open the test file
  vim.cmd('edit ' .. test_file)

  -- Wait for LSP to attach and diagnostics to appear
  local function check_lsp_status()
    -- Check if TypeScript LSP is attached
    -- FIXME: this needs to be updated with the new method
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    local is_attached = false
    for _, client in ipairs(clients) do
      if client.name == "tsserver" then
        is_attached = true
        break
      end
    end

    -- Get diagnostics for the current buffer
    local diagnostics = vim.diagnostic.get(0)

    -- Print status
    if is_attached then
      print("LSP Status: ✓ TypeScript LSP attached")
    else
      print("LSP Status: ✗ TypeScript LSP not attached")
      return false
    end

    if #diagnostics > 0 then
      print(string.format("Diagnostics: ✓ Found %d diagnostic messages", #diagnostics))
      -- Optionally print out the diagnostic messages
      for _, diagnostic in ipairs(diagnostics) do
        print(string.format("  - %s", diagnostic.message))
      end
    else
      print("Diagnostics: ✗ No diagnostic messages found")
      return false
    end

    return true
  end

  -- Wait for LSP and diagnostics with a timeout
  local timeout = 5000 -- 5 seconds
  local start_time = vim.loop.now()

  vim.defer_fn(function()
    local success = false
    while (vim.loop.now() - start_time) < timeout do
      success = check_lsp_status()
      if success then
        break
      end
      vim.cmd('sleep 100m') -- Wait 100ms between checks
    end

    -- Clean up
    vim.cmd('bdelete!')
    os.remove(test_file)

    if not success then
      print("Test failed: Timeout waiting for LSP or diagnostics")
    end
  end, 100) -- Start checking after 100ms initial delay
end

-- Add a command to run the test
vim.api.nvim_create_user_command('TestTSLSP', TestTypeScriptLSP, {})
