require("hacksore.core.options")
require("hacksore.core.keymaps")

-- Startup configuration
local function setup_startup()
  -- If arguments are passed (like nvim .), show neotree
  if vim.fn.argc() > 0 then
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.cmd("Alpha")
        vim.cmd("Neotree")
      end,
    })
  end
end

setup_startup()
