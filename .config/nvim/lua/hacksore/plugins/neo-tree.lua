-- tweaks for neo-tree
---@module "lazy"
---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  opts = {
    event_handlers = {
      {
        event = "file_opened",
        handler = function()
          -- auto close
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    },
    window = {
      position = "right",
      width = 70,
      mappings = {
        O = "system_open",
        Y = "copy_selector",
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = {
          ".git",
          ".DS_Store",
        },
      },
      components = {
        name = function(config, node, state)
          local components = require("neo-tree.sources.common.components")
          local name = components.name(config, node, state)
          if node:get_depth() == 1 then
            name.text = vim.fn.pathshorten(name.text, 2)
          end
          return name
        end,
      },
      commands = {
        system_open = function(state)
          vim.ui.open(state.tree:get_node():get_id())
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["EXTENSION"] = modify(filename, ":e"),
            ["PATH"] = filepath,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["FILENAME"] = filename,
            ["BASENAME"] = modify(filename, ":r"),
          }

          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ""
          end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            return
          end

          table.sort(options, function(a, b)
            return a < b
          end)

          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return ("%s: %s"):format(item, vals[item])
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.fn.setreg("+", result)
            end
          end)
        end,
      },
    },
    source_selector = {
      winbar = false,
    },
  },
}
