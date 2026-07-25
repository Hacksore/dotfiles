---@module "lazy"
---@type LazySpec
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")
    local comment_ft = require("Comment.ft")
    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
    local context_pre_hook = ts_context_commentstring.create_pre_hook()

    ---@diagnostic disable-next-line: missing-fields
    comment.setup({
      pre_hook = function(ctx)
        local ok, commentstring = pcall(context_pre_hook, ctx)

        if ok and commentstring then
          return commentstring
        end

        -- Context-aware comments require a Tree-sitter parser. Avoid a second
        -- Tree-sitter lookup when one is not installed.
        return comment_ft.get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring
      end,
    })
  end,
}
