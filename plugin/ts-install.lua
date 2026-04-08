-- Treesitter parser installer (lightweight alternative to nvim-treesitter)
-- Highlight, folding, and indent are handled natively by Neovim 0.12

require('ts-install').setup({
  auto_update = false,
  ensure_installed = {
    'typescript',
    'tsx',
    'javascript',
    'python',
    'lua',
    'dart',
    'json',
    'yaml',
    'toml',
    'html',
    'css',
    'markdown',
    'markdown_inline',
    'bash',
    'regex',
    'vim',
    'vimdoc',
    'dockerfile',
    'gitignore',
  },
  auto_install = true,
})
