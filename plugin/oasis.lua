-- Colorscheme: oasis (lagoon style)

require('oasis').setup({
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
