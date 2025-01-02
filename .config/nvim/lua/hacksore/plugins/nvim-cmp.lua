local function is_visible(cmp)
  return cmp.core.view:visible() or vim.fn.pumvisible() == 1
end

local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",   -- source for text in buffer
    "hrsh7th/cmp-path",     -- source for file system paths
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp, copilot = require("cmp"), require("copilot.suggestion")

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-j>"] = cmp.mapping(function(fallback)
          if copilot.is_visible() then
            copilot.accept()
          elseif is_visible(cmp) then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-K>"] = cmp.mapping(function(fallback)
          if is_visible(cmp) then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if is_visible(cmp) then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if is_visible(cmp) then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          entry_filter = function(entry)
            return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
          end,
        },
        { name = "luasnip" }, -- snippets
        { name = "buffer" },  -- text within current buffer
        { name = "path" },    -- file system paths
      }),

      -- configure lspkind for vs-code like pictograms in completion menu
      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        format = require("tailwindcss-colorizer-cmp").formatter
      },
    })
  end,
}
