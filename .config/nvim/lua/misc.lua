--relative line numbering
vim.api.nvim_set_option_value("number",true,{})
vim.api.nvim_set_option_value("relativenumber",true,{})

vim.api.nvim_create_augroup("numbertoggle",{})

vim.api.nvim_create_autocmd({"BufEnter","FocusGained","InsertLeave"},{pattern = "*",callback = function() vim.api.nvim_set_option_value("relativenumber", true, {}) end,group = "numbertoggle"})
vim.api.nvim_create_autocmd({"BufLeave","FocusLost","insertEnter"},{pattern = "*",callback = function() vim.api.nvim_set_option_value("relativenumber", false, {}) end,group = "numbertoggle"})

require("lualine").setup({
	options = { theme = "dracula" }
})

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})