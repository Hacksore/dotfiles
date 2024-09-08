return {
  "projekt0n/github-nvim-theme",
  priority = 1000,
  config = function()
    require('github-theme').setup({
      options = {
        terminal_colors = false,
      },
    })
    vim.cmd("colorscheme github_dark_default")
  end,
}
