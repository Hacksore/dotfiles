---@module "lazy"
---@type LazySpec
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      float_opts = {
        border = "curved",
      },
      highlights = {
        Normal = { link = "Normal" },
        NormalNC = { link = "NormalNC" },
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" },
      },
      size = 10,
    },
  },
}
