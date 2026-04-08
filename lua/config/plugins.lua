-- Plugin management via vim.pack (Neovim 0.12 built-in)

vim.pack.add({
  -- LSP server installer
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/neovim/nvim-lspconfig',

  -- Keymap visibility
  'https://github.com/echasnovski/mini.clue',

  -- File explorer
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',

  -- Icons (material style)
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/DaikyXendo/nvim-material-icon',

  -- Jupyter notebooks
  'https://github.com/benlubas/molten-nvim',
  'https://github.com/3rd/image.nvim',
}, { confirm = false })

-- Mason setup (must come before mason-lspconfig)
require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',
    'pyright',
    'ruff',
    'lua_ls',
  },
  -- Only auto-enable the servers we explicitly configured
  -- Prevents mason from enabling all installed servers (bashls, eslint, tailwindcss, etc.)
  automatic_enable = {
    'ts_ls',
    'pyright',
    'ruff',
    'lua_ls',
  },
})
-- dartls is not managed by mason (comes with Flutter SDK)
vim.lsp.enable('dartls')
