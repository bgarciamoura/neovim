-- Plugin management via vim.pack (Neovim 0.12 built-in)

vim.pack.add({
  -- LSP server installer
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/neovim/nvim-lspconfig',

  -- Treesitter parser management (main branch, rewritten for 0.12)
  'https://github.com/nvim-treesitter/nvim-treesitter',

  -- Textobjects via treesitter (no nvim-treesitter dependency)
  'https://github.com/echasnovski/mini.ai',

  -- Keymap visibility
  'https://github.com/echasnovski/mini.clue',

  -- Colorscheme
  'https://github.com/uhs-robert/oasis.nvim',

  -- Statusline
  'https://github.com/nvim-lualine/lualine.nvim',

  -- LSP progress
  'https://github.com/j-hui/fidget.nvim',

  -- Fuzzy finder
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',

  -- Git
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Formatting & linting
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',

  -- Editor
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/norcalli/nvim-colorizer.lua',

  -- JSON/YAML schema validation
  'https://github.com/b0o/SchemaStore.nvim',

  -- Debug
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/theHamsta/nvim-dap-virtual-text',

  -- Testing
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/neotest-jest',
  'https://github.com/marilari88/neotest-vitest',
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/sidlatau/neotest-dart',

  -- Terminal
  'https://github.com/akinsho/toggleterm.nvim',

  -- Flutter
  'https://github.com/akinsho/flutter-tools.nvim',

  -- File explorer
  'https://github.com/nvim-neo-tree/neo-tree.nvim',

  -- Icons (material style)
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/DaikyXendo/nvim-material-icon',

  -- Jupyter notebooks
  'https://github.com/benlubas/molten-nvim',
  'https://github.com/3rd/image.nvim',

  -- Shared dependencies
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-neotest/nvim-nio',
}, { confirm = false })

-- Mason setup (must come before mason-lspconfig)
require('mason').setup({
  ui = {
    border = 'rounded',
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
})

-- Auto-install tools via mason-registry
local registry = require('mason-registry')
local ensure_installed = {
  -- Formatters
  'prettierd',
  'black',
  'stylua',
  -- Linters
  'eslint_d',
  'ruff',
  'luacheck',
  'markdownlint',
  'hadolint',
  -- DAP adapters
  'js-debug-adapter',
  'debugpy',
}

registry.refresh(function()
  for _, pkg_name in ipairs(ensure_installed) do
    local ok, pkg = pcall(registry.get_package, pkg_name)
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end
end)

require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',
    'pyright',
    'ruff',
    'lua_ls',
    'jsonls',
    'yamlls',
    'html',
    'cssls',
    'taplo',
    'marksman',
    'dockerls',
    'docker_compose_language_service',
  },
  automatic_enable = {
    'ts_ls',
    'pyright',
    'ruff',
    'lua_ls',
    'jsonls',
    'yamlls',
    'html',
    'cssls',
    'taplo',
    'marksman',
    'dockerls',
    'docker_compose_language_service',
  },
})
