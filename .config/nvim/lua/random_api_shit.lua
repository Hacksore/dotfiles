--relative line numbering
vim.api.nvim_set_option_value("number",true,{})
vim.api.nvim_set_option_value("relativenumber",true,{})

vim.api.nvim_create_augroup("numbertoggle",{})

vim.api.nvim_create_autocmd({"BufEnter","FocusGained","InsertLeave"},{pattern = "*",callback = function() vim.api.nvim_set_option_value("relativenumber", true, {}) end,group = "numbertoggle"})
vim.api.nvim_create_autocmd({"BufLeave","FocusLost","insertEnter"},{pattern = "*",callback = function() vim.api.nvim_set_option_value("relativenumber", false, {}) end,group = "numbertoggle"})