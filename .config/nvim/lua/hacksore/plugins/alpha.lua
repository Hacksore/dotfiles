local function create_new_ts_file()
  vim.cmd("enew")
  vim.cmd("file sandbox.ts")

  -- Set filetype
  vim.bo.filetype = "typescript"
end

vim.api.nvim_create_user_command("NewTSFile", create_new_ts_file, {})

local function create_new_ts_project()
  local ts_project_name = os.date("%Y-%m-%d-%H-%M-%S")
  local ts_project_path = "/tmp/ts-sandbox/" .. ts_project_name
  vim.cmd("silent !mkdir -p " .. ts_project_path)

  vim.notify("Creating new TS project: " .. ts_project_path)
  vim.cmd("silent cd " .. ts_project_path)
  vim.cmd("silent !npx -y create-vite-app@latest . --template react-ts")

  -- open the app tsx in a new buffer
  vim.cmd("e src/App.tsx")

  -- install the deps with pnpm
  vim.notify("TS Sandbox installing deps with pnpm", "info", {})

  vim.fn.jobstart("pnpm i", {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("TS Sandbox failed to install deps", "error")
        return
      end

      vim.notify("TS Sandbox setup completed!", "info")

      -- give it some gitties
      vim.cmd("silent !git init")
      vim.cmd("silent !git add .")
      vim.cmd("silent !git commit -m 'Initial commit'")
    end,
  })
end

vim.api.nvim_create_user_command("NewTSProject", create_new_ts_project, {})

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("wr", "󰁯  > Restore Session", "<cmd>SessionRestore<CR>"),
      dashboard.button("nw", "  > New TS File", "<cmd>NewTSFile<CR>"),
      dashboard.button("nw", "  > New TS Project", "<cmd>NewTSProject<CR>"),
      dashboard.button("ee", "  > Toggle file explorer", "<cmd>Neotree toggle<CR>"),
      dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
