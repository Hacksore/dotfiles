local function create_new_ts_file()
  vim.cmd("enew")
  vim.cmd("file sandbox.ts")

  -- Set filetype
  vim.bo.filetype = "typescript"
end

vim.api.nvim_create_user_command("NewTSFile", create_new_ts_file, {})

local function create_new_ts_project()
  local home = vim.fn.getenv("HOME")
  local ts_project_name = os.date("%Y-%m-%d-%H-%M-%S")
  local ts_project_path = home .. "/sandbox/" .. ts_project_name
  vim.cmd("silent !mkdir -p " .. ts_project_path)

  vim.notify("Creating new TS project: " .. ts_project_path)
  vim.cmd("silent cd " .. ts_project_path)
  vim.cmd("silent !npx -y create-vite@latest . --template react-ts")

  -- open the app tsx in a new buffer
  vim.cmd("e src/App.tsx")

  -- install the deps with pnpm
  vim.notify("TS Sandbox installing deps with pnpm", vim.log.levels.INFO, {})

  vim.fn.jobstart("pnpm i", {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("TS Sandbox failed to install deps", vim.log.levels.ERROR)
        return
      end

      vim.notify("TS Sandbox setup completed!", vim.log.levels.INFO)

      -- give it some gitties
      vim.cmd("silent !git init -b main")
      vim.cmd("silent !git add .")
      vim.cmd("silent !git commit -m 'Initial commit'")
    end,
  })
end

vim.api.nvim_create_user_command("NewTSProject", create_new_ts_project, {})

local function validate_lsp()
  print("Starting LSP validation...")
  
  -- Get current buffer info
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)
  local filetype = vim.bo.filetype
  
  print("Current file: " .. current_file)
  print("Filetype: " .. filetype)
  
  -- Wait for LSP to initialize
  print("Waiting for LSP to initialize...")
  vim.wait(3000, function()
    local clients = vim.lsp.get_clients({ bufnr = current_buf })
    return #clients > 0
  end, 200)
  
  -- Check LSP status
  local clients = vim.lsp.get_clients({ bufnr = current_buf })
  print("LSP clients found: " .. #clients)
  
  if #clients == 0 then
    print("❌ ERROR: No LSP clients attached to current buffer")
    vim.cmd("cquit 1")
    return
  end
  
  local has_relevant_lsp = false
  for _, client in ipairs(clients) do
    print("- " .. client.name .. " (attached: " .. tostring(client.is_attached) .. ")")
    
    -- Check for TypeScript/JavaScript LSP
    if filetype == "typescript" or filetype == "typescriptreact" or filetype == "javascript" or filetype == "javascriptreact" then
      if client.name == "ts_ls" or client.name == "denols" then
        has_relevant_lsp = true
      end
    -- Check for other language-specific LSPs
    elseif filetype == "rust" and client.name == "rust_analyzer" then
      has_relevant_lsp = true
    elseif filetype == "lua" and client.name == "lua_ls" then
      has_relevant_lsp = true
    elseif filetype == "python" and client.name == "pylsp" then
      has_relevant_lsp = true
    else
      -- For other filetypes, any LSP is considered relevant
      has_relevant_lsp = true
    end
  end
  
  if not has_relevant_lsp then
    print("❌ ERROR: No relevant LSP found for filetype: " .. filetype)
    vim.cmd("cquit 1")
    return
  end
  
  -- Get diagnostics
  local diagnostics = vim.diagnostic.get(current_buf)
  print("Diagnostics found: " .. #diagnostics)
  
  for _, diag in ipairs(diagnostics) do
    local severity = "INFO"
    if diag.severity == vim.diagnostic.severity.ERROR then
      severity = "ERROR"
    elseif diag.severity == vim.diagnostic.severity.WARN then
      severity = "WARN"
    elseif diag.severity == vim.diagnostic.severity.HINT then
      severity = "HINT"
    end
    print("- Line " .. (diag.lnum + 1) .. " [" .. severity .. "]: " .. diag.message)
  end
  
  -- Test LSP capabilities
  if #clients > 0 then
    local client = clients[1]
    print("LSP Capabilities:")
    if client.server_capabilities.completionProvider then
      print("✓ Completion available")
    end
    if client.server_capabilities.hoverProvider then
      print("✓ Hover available")
    end
    if client.server_capabilities.diagnosticProvider then
      print("✓ Diagnostics available")
    end
    if client.server_capabilities.definitionProvider then
      print("✓ Go to definition available")
    end
    if client.server_capabilities.referencesProvider then
      print("✓ Find references available")
    end
  end
  
  print("✅ SUCCESS: LSP validation completed!")
end

vim.api.nvim_create_user_command("ValidateLSP", validate_lsp, {})

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
      dashboard.button("r", "󰁯  > Restore Session", "<cmd>SessionRestore<CR>"),
      dashboard.button("p", "  > New Vite Project", "<cmd>NewTSProject<CR>"),
      dashboard.button("n", "  > New TS File", "<cmd>NewTSFile<CR>"),
      dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
