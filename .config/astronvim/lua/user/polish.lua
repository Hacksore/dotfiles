return function()
  vim.filetype.add {
    extension = {
      mdx = "markdown",
    },
    filename = {
      [".zshrc"] = "sh",
    },
  }
end
