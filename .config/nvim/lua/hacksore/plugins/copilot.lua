return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      -- check if there is a .disablecopilot in the home directory
      local home = os.getenv("HOME")
      if vim.fn.filereadable(home .. "/.disablecopilot") == 1 then
        return
      end

      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 150,
          keymap = {
            accept = "<C-j>",
            dismiss = "<C-k>",
          },
        },
      })
    end,
  },
}
