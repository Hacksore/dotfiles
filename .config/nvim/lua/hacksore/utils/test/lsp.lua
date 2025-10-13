local M = {}

M.MAX_LSP_TIMEOUT = 10000
M.TYPESCRIPT_CLIENT_NAME = "ts_ls"

--- Utility function to get current buffer info
--- @returns table with buffer number, file name, and filetype
--- @returns {buf: number, file: string, filetype: string}
M.get_buffer_info = function()
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
M.wait_for_diagnostics = function(bufnr, client_name)
  local ready = false

  local aug = vim.api.nvim_create_augroup("WaitForDiagnostics", { clear = true })
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = aug,
    buffer = bufnr,
    callback = function()
      local diagnostics = vim.diagnostic.get(bufnr)
      for _, diag in ipairs(diagnostics) do
        if diag.source == client_name then
          ready = true
          vim.api.nvim_del_augroup_by_id(aug)
          break
        end
      end
    end,
  })

  vim.wait(M.MAX_LSP_TIMEOUT, function()
    return ready
  end, 200)
end

return M
