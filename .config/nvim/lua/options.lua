--mouse usage
vim.o.mouse = 'a'

--add recursive search to path
vim.o.path = vim.o.path .. ',**'

-- TODO: nodules are fucked :fin <earch>

--use clipboard as plus and star registers
vim.o.clipboard = 'unnamedplus'

-- buffer on bottom and top when scrolling
vim.o.scrolloff = 4
vim.cmd('highlight WinSeparator guibg=None')

--wildcard ignore case
vim.o.wic = true

-- global status line
vim.o.laststatus = 3

-- make harpoon useless
vim.cmd('autocmd BufEnter * norm \'"')

-- don't split on word when wrapping lines
vim.o.linebreak = true

-- set one dark theme
vim.cmd "colorscheme onedark"
