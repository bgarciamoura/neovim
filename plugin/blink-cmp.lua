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

-- LLM completion (minuet) is triggered on demand with <A-y>; the source is
-- deliberately kept out of `default` so it never fires as-you-type.
local keymap = { preset = 'super-tab' }
local ok_minuet, minuet = pcall(require, 'minuet')
if ok_minuet then
  keymap['<A-y>'] = minuet.make_blink_map()
end

blink.setup({
  keymap = keymap,

  appearance = {
    nerd_font_variant = 'mono',
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      -- Slash commands, variables and tools inside CodeCompanion chat buffers
      codecompanion = { 'codecompanion' },
    },
    providers = {
      snippets = {
        opts = {
          search_paths = {
            vim.fs.joinpath(vim.fn.stdpath('config'), 'snippets'),
          },
        },
      },
      minuet = {
        name = 'minuet',
        module = 'minuet.blink',
        async = true,
        timeout_ms = 5000,
        score_offset = 50,
      },
    },
  },

  completion = {
    trigger = {
      -- Recommended by minuet: avoid prefetching LLM completions on InsertEnter
      prefetch_on_insert = false,
    },
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
