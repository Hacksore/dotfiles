---@module "lazy"
---@type LazySpec
return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  version = "*",
  opts = {
    options = {
      indicator = {
        style = "none",
      },
      show_close_icon = false,
      show_buffer_close_icons = false,
    },
  },
}
