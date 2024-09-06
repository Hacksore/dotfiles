return {
  "folke/noice.nvim",
  event = "VeryLazy",
  config = function()
    -- TODO: should this be merging the table too?
    require("noice").setup({
      messages = { view_search = false },
      views = {
        cmdline_popup = {
          position = {
            row = 4,
            col = "50%",
          },
        },
      },
      routes = {
        { filter = { event = "msg_show", find = "%d+L,%s%d+B" },        opts = { skip = true } }, -- skip save notifications
        { filter = { event = "msg_show", find = "^%d+ more lines$" },   opts = { skip = true } }, -- skip paste notifications
        { filter = { event = "msg_show", find = "^%d+ fewer lines$" },  opts = { skip = true } }, -- skip delete notifications
        { filter = { event = "msg_show", find = "^%d+ lines yanked$" }, opts = { skip = true } }, -- skip yank notifications
      },
      lsp = {
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
    })
  end,
}
