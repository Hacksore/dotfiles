---@module "lazy"
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- configure treesitter
    require("nvim-treesitter").setup()

    -- enable syntax highlighting and indentation
    local augroup = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      callback = function()
        local ok = pcall(vim.treesitter.start)
        if ok then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- enable autotagging (w/ nvim-ts-autotag plugin)
    require("nvim-ts-autotag").setup()
  end,
}
