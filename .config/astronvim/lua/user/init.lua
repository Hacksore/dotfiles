return {
  -- any custom config
  options = {
    opt = {
      spell = true, -- Enable spell checking 
      title = true,
    },
  },
  updater = {
    channel = "stable",
    remote = "origin",
    version = "latest",
    branch = "main",
  },
  lsp = {
    servers = {
      "dockerls",
      "yamlls",
      "gopls"
    },
    formatting = {
      format_on_save = {
        enabled = false, -- disable format on save
      },
    },
  },
}
