return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = {
    "rafamadriz/friendly-snippets",
    "giuxtaposition/blink-cmp-copilot",
  },
  -- use a release tag to download pre-built binaries
  -- This means you have to install and configure rust nightly
  -- rustup install nightly
  build = "cargo +nightly build --release",

  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "none",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Enter>"] = { "select_and_accept", "fallback" },
      ["<C-Space>"] = { "show", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<C-l>"] = { "hide", "fallback" },
    },

    appearance = {
      nerd_font_variant = "normal"
    },
    completion = {
      documentation = { auto_show = false },
      menu = {
        draw = {
          components = {
            label_description = {
              text = function(ctx)
                return ctx.label_description ~= '' and ctx.label_description or ctx.item.detail
              end,
            },
          },
        },
      }
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust" }
  },
  opts_extend = { "sources.default" }
}
