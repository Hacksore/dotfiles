-- NOTE: testing
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo_comments = require("todo-comments")
    todo_comments.setup({
      keywords = {
        NOTE = { icon = " ", color = "warning" },
      },
      search = {
        command = "rg",
        args = {
          "--hidden",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    })
  end,
}
