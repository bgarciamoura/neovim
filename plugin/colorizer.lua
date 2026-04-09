-- Inline color preview

local ok, colorizer = pcall(require, 'colorizer')
if not ok then return end

colorizer.setup({
  'css',
  'scss',
  'html',
  'javascript',
  'typescript',
  'typescriptreact',
  'javascriptreact',
  'lua',
  '*',
})
