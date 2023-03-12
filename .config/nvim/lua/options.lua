--mouse usage
vim.o.mouse = "a"

--add recursive search to path
vim.o.path = vim.o.path .. ",**"

vim.o.wildignore = "**/node_modules/*"

--use clipboard as plus and star registers
vim.o.clipboard = "unnamedplus"

-- buffer on bottom and top when scrolling
vim.o.scrolloff = 4
vim.cmd("highlight WinSeparator guibg=None")

--wildcard ignore case
vim.o.wic = true

-- global status line
vim.o.laststatus = 3

-- don"t split on word when wrapping lines
vim.o.linebreak = true

-- set tab size
vim.o.shiftwidth = 0
vim.o.softtabstop = 0
vim.o.tabstop = 2
vim.o.expandtab = true

-- set sign column to yes
vim.o.signcolumn = "yes"

-- set one dark theme
vim.cmd("colorscheme onedark")

-- allow for persistent undo, lets you close files and save undo/redo buffer
vim.o.undofile = true
