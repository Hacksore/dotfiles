local theme = require("hacksore.core.utils.theme")
local keymap = vim.keymap

-- tmux
keymap.set("n", "<Leader>gg", "<cmd>silent !tmux neww lazygit<cr>", { desc = "Open lazygit in tmux" })
keymap.set("n", "<C-n>", function()
  vim.fn.system("tmux switch-client -n")
end, { desc = "Switch tmux session forward" })
keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<cr>", { desc = "Open tmux sessionizer" })

keymap.set("n", "<C-p>", function()
  vim.fn.system("tmux switch-client -p")
end, { desc = "Switch tmux session back" })

-- neotree
keymap.set("n", "<Leader>e", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Explorer" })
keymap.set("n", "<Leader>o", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd.wincmd("p")
  else
    vim.cmd.Neotree("focus")
  end
end, {
  desc = "Toggle Explorer Focus",
})

-- toggle term keys
keymap.set("n", "<Leader>tf", "<Cmd>ToggleTerm direction=float<CR>", { desc = "ToggleTerm float" })
keymap.set("n", "<Leader>th", "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", { desc = "ToggleTerm horiz" })
keymap.set("n", "<Leader>tv", "<Cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "ToggleTerm vert" })

keymap.set("t", "<C-H>", "<Cmd>wincmd h<CR>", { desc = "Terminal left window navigation" })
keymap.set("t", "<C-J>", "<Cmd>wincmd j<CR>", { desc = "Terminal down window navigation" })
keymap.set("t", "<C-K>", "<Cmd>wincmd k<CR>", { desc = "Terminal up window navigation" })
keymap.set("t", "<C-L>", "<Cmd>wincmd l<CR>", { desc = "Terminal right window navigation" })

-- format
keymap.set("n", "<Leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })

-- lsp things
keymap.set("n", "<Leader>ld", vim.diagnostic.open_float, { desc = "Hover diagnostics" })
keymap.set("n", "<Leader>la", vim.lsp.buf.code_action, { desc = "Hover diagnostics" })
keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { desc = "Hover diagnostics" })

keymap.set("n", "gd", function()
  vim.lsp.buf.definition({
    on_list = function(t)
      -- I like to jump directly to the file instead of doing a split buffer
      local file = t.items[1]
      vim.lsp.util.show_document(file.user_data, "utf-8", { focus = true })
    end,
  })
end, { desc = "Goto LSP definition" })

-- random things
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap.set("n", "fn", "<Cmd>enew<CR>", { desc = "Open a new window" })

-- stop pasted text from writing the text into clipboard buffer
keymap.set("v", "p", [["_dP]], { desc = "Paste without yanking" })

-- navigation
keymap.set("n", "<Leader>n", "<Cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<Leader>p", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- quick key to switch themes
keymap.set("n", "<Leader>0", function()
  theme.switch(1)
end, { desc = "Next theme" })
keymap.set("n", "<Leader>9", function()
  theme.switch(-1)
end, { desc = "Prev theme" })

-- quick key to toggle theme from light to dark
keymap.set("n", "<Leader>ll", function()
  theme.toggle()
end, { desc = "Toggle theme light/dark" })
