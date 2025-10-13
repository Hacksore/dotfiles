---@module "lazy"
---@type LazySpec
return {
  "mbbill/undotree",
  lazy = false,
  config = function()
    -- Set options directly in Lua
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_DiffpanelHeight = 8

    if vim.fn.has("persistent_undo") == 1 then
      local target_path = vim.fn.expand("~/.undodir")

      -- Create the directory and any parent directories
      -- if the location does not exist.
      if vim.fn.isdirectory(target_path) == 0 then
        vim.fn.mkdir(target_path, "p", "0700")
      end

      vim.opt.undodir = target_path
      vim.opt.undofile = true
    end

    vim.keymap.set("n", "<leader>tu", function()
      vim.api.nvim_command("UndotreeToggle")
    end, {})
  end,
}
