-- Treesitter parser management via nvim-treesitter (main branch for 0.12)
-- Highlight, folding, and commenting are handled natively by Neovim 0.12
-- nvim-treesitter is used ONLY for parser installation and query files

require('nvim-treesitter').setup({
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
