-- Filename label on each window (the statusline is global, so it only names
-- the active one)

local ok, incline = pcall(require, 'incline')
if not ok then return end

incline.setup({
  window = {
    margin = { vertical = 0, horizontal = 1 },
    zindex = 10,
  },
  hide = {
    cursorline = 'smart',
  },
  render = function(props)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
    if name == '' then name = '[No Name]' end
    if vim.bo[props.buf].modified then name = '[+] ' .. name end

    local icon, color = require('nvim-web-devicons').get_icon_color(name, nil, { default = true })
    return { { icon, guifg = color }, { ' ' }, { name } }
  end,
})
