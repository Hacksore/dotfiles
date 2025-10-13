---@module "lazy"
---@type LazySpec
return {
  "kevinhwang91/nvim-ufo",
  event = "VeryLazy",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  opts = {
    provider_selector = function()
      return { "treesitter", "indent" }
    end,
    open_fold_hl_timeout = 400,
  },
  init = function()
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.foldcolumn = "1" -- show foldcolumn
    vim.o.foldenable = true -- enable fold for nvim-ufo
    vim.o.foldlevel = 99 -- set high foldlevel for nvim-ufo
    vim.o.foldlevelstart = 99 -- start with all code unfolded
  end,
}
