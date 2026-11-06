-- Statusline

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ''
  end
  local names = {}
  for _, c in ipairs(clients) do
    table.insert(names, c.name)
  end
  return ' ' .. table.concat(names, ', ')
end

-- cmdheight=0 hides Neovim's own "recording @q" message.
local function macro_recording()
  local register = vim.fn.reg_recording()
  if register == '' then
    return ''
  end
  return '\u{f111} REC @' .. register
end

local ok, lualine = pcall(require, 'lualine')
if not ok then return end

lualine.setup({
  options = {
    icons_enabled = true,
    theme = 'oasis',
    globalstatus = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha', 'dashboard', 'starter' },
    },
    always_divide_middle = true,
    refresh = { statusline = 100 },
  },

  sections = {
    lualine_a = {
      {
        'mode',
        separator = { left = '', right = '' },
        padding = { left = 1, right = 1 },
      },
    },
    lualine_b = {
      {
        'branch',
        icon = '',
        separator = { right = '' },
      },
      {
        'diff',
        symbols = {
          added = ' ',
          modified = ' ',
          removed = ' ',
        },
      },
    },
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = ' ●',
          readonly = ' ',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = {
          error = ' ',
          warn = ' ',
          hint = ' ',
          info = ' ',
        },
        colored = true,
      },
    },

    lualine_x = {
      { macro_recording, color = 'DiagnosticError' },
      { lsp_clients },
      { 'filetype' },
    },
    lualine_y = {
      {
        'progress',
        separator = { left = '' },
      },
    },
    lualine_z = {
      {
        'location',
        separator = { left = '', right = '' },
        padding = { left = 1, right = 1 },
      },
    },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = { modified = ' ●', readonly = ' ' },
      },
    },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },

  extensions = { 'neo-tree', 'lazy', 'mason', 'toggleterm' },
})
