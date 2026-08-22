-- Plugin management via vim.pack (Neovim 0.12 built-in)

-- Build hooks: vim.pack has no `build` key, so run post-install/update steps
-- via the PackChanged event (see :h PackChanged).
local build_hooks = {
  -- avante.nvim ships native libs (tokenizers, templates, …). Our script
  -- downloads the prebuilt release for the checked-out tag via curl+tar;
  -- `make` would compile from source and require cargo.
  ['avante.nvim'] = { 'bash', vim.fs.joinpath(vim.fn.stdpath('config'), 'scripts', 'avante-build.sh') },
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('config_pack_build', { clear = true }),
  callback = function(ev)
    local data = ev.data
    local cmd = build_hooks[data.spec.name]
    if not cmd or (data.kind ~= 'install' and data.kind ~= 'update') then return end

    vim.notify(('Building %s…'):format(data.spec.name), vim.log.levels.INFO)
    vim.system(cmd, { cwd = data.path }, function(result)
      vim.schedule(function()
        if result.code == 0 then
          vim.notify(('%s built — restart Neovim to load it'):format(data.spec.name), vim.log.levels.INFO)
        else
          vim.notify(
            ('%s build failed (exit %d):\n%s'):format(data.spec.name, result.code, result.stderr or ''),
            vim.log.levels.ERROR
          )
        end
      end)
    end)
  end,
})

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

  -- Dashboard
  'https://github.com/goolord/alpha-nvim',

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

  -- Markdown
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/iamcco/markdown-preview.nvim',

  -- Session
  'https://github.com/folke/persistence.nvim',

  -- Tiny UI enhancements
  'https://github.com/rachartier/tiny-inline-diagnostic.nvim',
  'https://github.com/rachartier/tiny-cmdline.nvim',
  'https://github.com/rachartier/tiny-code-action.nvim',

  -- Completion (pinned to 1.x: v2 requires blink.lib and a different config;
  -- plugin/blink-cmp.lua targets the v1.10 prebuilt fuzzy binary)
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('^1.10.0') },
  'https://github.com/rafamadriz/friendly-snippets',

  -- AI / LLM (Groq API — see plugin/codecompanion.lua, avante.lua, minuet.lua)
  { src = 'https://github.com/olimorris/codecompanion.nvim', version = vim.version.range('^19.0.0') },
  'https://github.com/avante-corp/avante.nvim',
  'https://github.com/milanglacier/minuet-ai.nvim',

  -- HTTP client (.http files, for calling LLM APIs directly)
  'https://github.com/mistweaverco/kulala.nvim',

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
    'eslint',
    'biome',
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
    'eslint',
    'biome',
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
