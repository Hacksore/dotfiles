return {
  -- any custom config
  options = {
    opt = {
      showtabline = 0, -- don't show tabline
      spell = true, -- Enable spell checking 
    },
  },
  updater = {
    channel = "stable",
    remote = "origin",
    version = "latest",
    branch = "main",
  },
}
