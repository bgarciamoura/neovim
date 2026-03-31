return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      -- ── Appearance ────────────────────────────────────────────────────────
      appearance = {
        nerd_font_variant = "mono",
      },

      -- ── Keymaps ───────────────────────────────────────────────────────────
      keymap = {
        preset = "default",

        -- Show / toggle docs
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        -- Hide the completion menu
        ["<C-e>"] = { "hide", "fallback" },
        -- Accept the selected item
        ["<CR>"] = { "accept", "fallback" },

        -- Navigate items
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },

        -- Scroll documentation
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        -- Tab: navigate or expand snippet; S-Tab: go backwards
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },

      -- ── Completion ────────────────────────────────────────────────────────
      completion = {
        -- Auto-insert brackets for function/method completions
        accept = {
          auto_brackets = { enabled = true },
        },

        -- Documentation popup
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
          },
        },

        -- Completion menu
        menu = {
          border = "rounded",
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },

        -- Ghost text disabled
        ghost_text = {
          enabled = false,
        },
      },

      -- ── Sources ───────────────────────────────────────────────────────────
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
