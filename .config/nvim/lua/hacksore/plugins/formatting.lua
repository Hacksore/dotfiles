---@module "lazy"
---@type LazySpec
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
    },
    formatters = {
      shfmt = {
        args = { "-filename", "$FILENAME" },
      },
    },
    format_on_save = nil,
  },
}
