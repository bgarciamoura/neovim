-- Inline markdown rendering inside Neovim buffers

local ok, render_md = pcall(require, 'render-markdown')
if not ok then return end

vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#162133' })
vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = '#162133' })
vim.api.nvim_set_hl(0, 'RenderMarkdownCodeBorder', { bg = '#21324D', fg = '#7aa2f7' })

render_md.setup({
  render_modes = { 'n', 'c' },
  anti_conceal = {
    enabled = false,
  },
  heading = {
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
  },
  code = {
    enabled = true,
    sign = true,
    style = 'full',
    width = 'block',
  },
  bullet = {
    icons = { '●', '○', '◆', '◇' },
  },
  checkbox = {
    unchecked = { icon = '  ' },
    checked = { icon = '  ' },
  },
})
