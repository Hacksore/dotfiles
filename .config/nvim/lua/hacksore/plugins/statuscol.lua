return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      -- configuration goes here, for example:
      relculright = true,
      segments = {
        -- Show the number column
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
        -- Show git status
        {
          sign = {
            namespace = { "gitsign" },
            maxwidth = 1,
            colwidth = 1,
            auto = false,
          },
          click = "v:lua.ScSa",
        },
        -- Show LSP diagnostic signs
        {
          sign = {
            namespace = { "diagnostic" },
            maxwidth = 1,
            colwidth = 1,
            auto = false,
          },
          click = "v:lua.ScSa",
        },
        -- Padding
        { text = { " " } },
      },
    })
  end,
}
