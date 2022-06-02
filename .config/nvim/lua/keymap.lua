local M = {}

function M.bind(mode, keys, func)
    vim.api.nvim_set_keymap(mode, keys, func, { noremap = true, silent = true })
end

function M.normal(key, func)
    M.bind("n", key, func)
end

function M.visual(key, func)
    M.bind("v", key, func)
end

function M.insert(key, func)
    M.bind("i", key, func)
end

-- TODO: refactor to use tghe methods above
vim.api.nvim_set_keymap("n", "T", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ez", ":tabedit $HOME/.zshrc<CR>", { noremap = true, silent = true })

--Escape leaves input mode in neovim-terminal
vim.api.nvim_set_keymap('t', '<Esc>','<c-\\><C-n>',{})

-- meta+s saves the file - sorry VIM fam it's ok
M.normal("<C-s>", ":update<CR>")
M.insert("<C-s>", "<ESC>:update<CR>")


