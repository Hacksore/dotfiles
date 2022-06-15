local M = {}

function M.bind(mode, keys, func, tab)
    local t = tab and tab or {}
    vim.api.nvim_set_keymap(mode, keys, func, t)
end

function M.normal(key, func, tab)
    M.bind("n", key, func, tab)
end

function M.visual(key, func, tab)
    M.bind("v", key, func, tab)
end

function M.insert(key, func, tab)
    M.bind("i", key, func, tab)
end

function M.terminal(key, func, tab)
    M.bind("t", key, func, tab)
end

-- set leader key
vim.cmd 'let mapleader = " "' 

-- disable swap files
vim.cmd 'set noswapfile'

-- telescope gitfules 
M.normal("T", ":Telescope git_files<CR>", { noremap = true, silent = true }) 


-- switch buffers TODO:
-- M.normal("<Tab>", ":Telescope git_files<CR>", { noremap = true, silent = true }) 

-- indent with sane keys
--M.insert("<Tab>", "<C-t>", { noremap = true, silent = true })
M.insert("<S-Tab>", "<C-d>")


-- copilot
-- vim.g.copilot_no_tab_map = true
--vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""

-- copilot active via control+i
-- M.insert("<C-i>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

-- Escape leaves input mode in neovim-terminal
M.terminal("<Esc>","<c-\\><C-n>")

-- meta+s saves the file - sorry VIM fam it's ok
M.normal("<C-s>", ":update<CR>")
M.insert("<C-s>", "<ESC>:update<CR>")

-- disalbe space in nromal mode
M.normal("<Space>", "")

