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

function M.terminal(key, func)
    M.bind("t", key, func)
end

-- set leader key
vim.cmd 'let mapleader = " "' 

-- 
M.normal("<leader>t", ":Telescope git_files<CR>") 

--Escape leaves input mode in neovim-terminal
M.terminal("<Esc>","<c-\\><C-n>")

-- meta+s saves the file - sorry VIM fam it's ok
M.normal("<C-s>", ":update<CR>")
M.insert("<C-s>", "<ESC>:update<CR>")

M.normal("<Space>", "")

