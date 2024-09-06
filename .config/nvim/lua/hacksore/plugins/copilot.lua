return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 150,
          keymap = {
            -- Nice key to accept so it wont interfere with autocomplete
            accept = "<C-J>",
            -- Nice to dismiss it
            dismiss = "<C-K>",
          },
        },
      })
    end,
  },
}
