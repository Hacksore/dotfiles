return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  version = "*",
  opts = {
    options = {
      indicator = {
        style = 'none',
      },
      show_close_icon = false,
      show_buffer_close_icons = false
    },
    highlights = {
      background = {
        bg = "#0D1117",
      },
      buffer_selected = {
        bg = "#19202A",
        bold = true,
      },
    }
  },
}
