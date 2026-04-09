-- Inline diagnostic overlay (replaces virtual_text)

local ok, tid = pcall(require, 'tiny-inline-diagnostic')
if not ok then return end

tid.setup({
  preset = 'modern',
  options = {
    show_source = true,
    transparent_bg = true,
    multilines = { enabled = true },
    softwrap = 15,
    overflow = { mode = 'wrap' },
  },
})
