-- Colorscheme: oasis (lagoon style)

local ok, oasis = pcall(require, 'oasis')
if not ok then return end

oasis.setup({
  style = 'lagoon',
  themed_syntax = true,
  styles = {
    bold = true,
    italic = true,
    underline = true,
    undercurl = true,
    strikethrough = true,
  },
  transparent = false,
  terminal_colors = true,
})

vim.cmd.colorscheme('oasis')
