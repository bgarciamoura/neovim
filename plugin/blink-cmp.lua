require('blink.cmp').setup({
  keymap = { preset = 'super-tab' },

  appearance = {
    nerd_font_variant = 'mono',
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  completion = {
    menu = {
      border = 'rounded',
      scrollbar = true,
    },
    documentation = {
      auto_show = true,
      window = { border = 'rounded' },
    },
    ghost_text = { enabled = true },
  },

  fuzzy = {
    implementation = 'prefer_rust_with_warning',
    prebuilt_binaries = {
      download = true,
      force_version = 'v1.10.2',
    },
  },
})
