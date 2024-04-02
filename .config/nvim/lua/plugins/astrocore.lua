---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      notifications = false, -- enable notifications at start
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
			  spell = true, -- Enable spell checking
			  wrap = true,
			  spellfile = vim.fn.expand("~/.config/astronvim/spell/en.utf-8.add"),
			  swapfile = false,    -- Disable swap files
			  title = true,        -- Allow nvim to update the term title
			  relativenumber = false, -- Disable relative line numbers
      },
    },
  },
}
