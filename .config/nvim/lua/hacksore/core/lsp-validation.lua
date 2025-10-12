local M = {}

local function validate_lsp()
  print("Starting LSP validation...")

  -- Get current buffer info
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)
  local filetype = vim.bo.filetype

  print("Current file: " .. current_file)
  print("Filetype: " .. filetype)
  print("Buffer number: " .. current_buf)

  -- Wait for LSP to initialize
  print("Waiting for LSP to initialize...")

  local ts_client = nil

  local function validte_ts_lsp()
    local diagnostics = vim.diagnostic.get(current_buf)

    for _, diag in ipairs(diagnostics) do
      print(diag.source .. ": " .. diag.message)
    end
  end

  -- how can we get a ready even for when the LSP is attached?
  vim.wait(5000, function()
    local clients = vim.lsp.get_clients({ bufnr = current_buf })

    for _, client in ipairs(clients) do
      if client.name == "ts_ls" then
        validte_ts_lsp()
        break
      end
    end

    return false
  end)

  if ts_client == nil then
    print("LSP client 'ts_ls' not attached within timeout.")
    return
  end

  print("")
end

M.setup = function()
  vim.api.nvim_create_user_command("TestTypescriptLSP", validate_lsp, {})
end

return M
