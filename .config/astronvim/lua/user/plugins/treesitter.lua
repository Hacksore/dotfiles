return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    -- this gives comments based on the context you are in allowing you to comment JSX nicely
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  opts = {
    ensure_installed = {
      "bash",
      "css",
      "dockerfile",
      "html",
      "javascript",
      "json",
      "lua",
      "python",
      "rust",
      "toml",
      "typescript",
      "tsx",
      "diff",
      "ini",
      "astro",
      "vue",
      "yaml",
      "ruby",
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  }
}
