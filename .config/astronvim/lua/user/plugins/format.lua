return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    vim.inspect(null_ls.builtins.formatting)

    opts.sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.rustfmt,
      null_ls.builtins.formatting.shfmt.with {
        args = { "-i", "2" },
      },
    }
    return opts
  end,
	event = "User Astrofile",
}
