return function()
  -- FileType
  vim.filetype.add {
    extension = {
      mdx = "markdown",
    },
    filename = {
      [".zshrc"] = "sh",
    },
  }
end
