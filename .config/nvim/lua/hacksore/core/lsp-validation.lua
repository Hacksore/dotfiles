local M = {}

local function validate_lsp()
  local current_buf = vim.api.nvim_get_current_buf()

  -- Force LSP attachment by triggering diagnostics
  vim.cmd("doautocmd BufEnter")
  vim.cmd("doautocmd FileType")

  local function check_diagnostics()
    local diagnostics = vim.diagnostic.get(current_buf)

    if vim.tbl_isempty(diagnostics) then
      print("No diagnostics found for the current buffer.")
      return
    end

    print("Diagnostics for the current buffer:")

    for _, diag in ipairs(diagnostics) do
      print(diag.source .. ": " .. diag.message)
    end
  end

  -- Wait for ts_ls to attach, then call function once
  local wait_result = vim.wait(5000, function()
    local clients = vim.lsp.get_clients({ bufnr = current_buf })

    for _, client in ipairs(clients) do
      if client.name == "ts_ls"  then
        print("TypeScript LSP (ts_ls) is active, stop polling now!")
        check_diagnostics()
        return true -- Stop polling when found
      end
    end

    return false -- Continue polling
  end, 100)

  if not wait_result then
    print("⚠️  WARNING: Timeout waiting for relevant LSP client to attach")
  end

  print("")
end

M.setup = function()
  vim.api.nvim_create_user_command("TestTypescriptLSP", validate_lsp, {})
end

return M
