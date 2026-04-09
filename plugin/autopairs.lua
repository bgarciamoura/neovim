-- Auto close brackets

local ok, autopairs = pcall(require, 'nvim-autopairs')
if not ok then return end

autopairs.setup({
  check_ts = true,
  ts_config = {
    lua = { 'string' },
    javascript = { 'template_string' },
    typescript = { 'template_string' },
  },
  fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = [=[[%'%"%>%]%)%}%,]]=],
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    manual_position = true,
    highlight = 'Search',
    highlight_grey = 'Comment',
  },
})
