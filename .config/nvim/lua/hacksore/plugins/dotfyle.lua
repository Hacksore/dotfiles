---@module "lazy"
---@type LazySpec
return {
  "creativenull/dotfyle-metadata.nvim",
  config = function()
    local augroup = vim.api.nvim_create_augroup("DotfyleMetadataGroup", {})
    vim.api.nvim_create_autocmd("User", {
      group = augroup,
      pattern = { "LazyUpdate", "LazyInstall", "LazySync", "LazyClean" },
      once = true,
      callback = function()
        local dotfyle_metadata = require("dotfyle_metadata")
        dotfyle_metadata.generate({})
        local home = vim.fn.getenv("HOME")
        vim.cmd("!npx prettier --write " .. dotfyle_metadata.dotfyle_path)
        local move_dir_string = string.format("!mv %s %s", dotfyle_metadata.dotfyle_path, home .. "/.config/nvim")
        vim.cmd(move_dir_string)
      end,
    })
  end,
  event = "VeryLazy",
}
