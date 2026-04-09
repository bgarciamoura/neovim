-- Git signs in the gutter

local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then return end

gitsigns.setup({
  signs = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '' },
    topdelete    = { text = '' },
    changedelete = { text = '▎' },
    untracked    = { text = '▎' },
  },
  signs_staged = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '' },
    topdelete    = { text = '' },
    changedelete = { text = '▎' },
    untracked    = { text = '▎' },
  },
  current_line_blame = false,
  current_line_blame_opts = {
    delay = 300,
    virt_text_pos = 'eol',
  },
})
