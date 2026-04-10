-- Ensure blink.cmp is on runtimepath (vim.pack uses opt/)
local blink_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt', 'blink.cmp')
if vim.uv.fs_stat(blink_path) and not vim.list_contains(vim.opt.rtp:get(), blink_path) then
  vim.opt.rtp:prepend(blink_path)
end

local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  vim.notify('blink.cmp not found — restart Neovim after plugins install', vim.log.levels.WARN)
  return
end

blink.setup({
  keymap = { preset = 'super-tab' },

  appearance = {
    nerd_font_variant = 'mono',
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      snippets = {
        opts = {
          search_paths = {
            vim.fs.joinpath(vim.fn.stdpath('config'), 'snippets'),
          },
        },
      },
    },
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
