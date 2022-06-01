vim.api.nvim_set_keymap("n", "T", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ez", ":tabedit $HOME/.zshrc<CR>", { noremap = true, silent = true })

--Escape leaves input mode in neovim-terminal
vim.api.nvim_set_keymap('t', '<Esc>','<c-\\><C-n>',{})

-- exmaple how to go to thin in ts
-- vim.api.nvim_set_keymap("n", "T", ":Telescope git_status<CR>", { noremap = true, silent = true })



