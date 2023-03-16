-- open tele
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><Tab>", builtin.git_files, {})

-- indent with sane keys
vim.keymap.set("i", "<S-Tab>", "<C-d>")

-- Escape leaves input mode in neovim-terminal
vim.keymap.set("t", "<Esc>","<c-\\><C-n>")

-- allow tree toggle?
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")