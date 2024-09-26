local vim = vim
-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  return
end

-- Start setup
lazy.setup({
  spec = {
    -- Icons
    { 'kyazdani42/nvim-web-devicons', lazy = true },
    -- "nvim-tree/nvim-web-devicons"

    -- Gitsigns
    { 'lewis6991/gitsigns.nvim',      lazy = true },

    -- Statusline
    {
      'freddiehaddad/feline.nvim',
      dependencies = {
        'kyazdani42/nvim-web-devicons',
        'lewis6991/gitsigns.nvim',
      },
    },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- Autopair
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        require('nvim-autopairs').setup {}
      end
    },

    -- File Tree
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
    },

    { "mattn/emmet-vim",                 lazy = true },

    -- { "Exafunction/codeium.vim",   event = "BufEnter" },
    { "github/copilot.vim",              event = "BufEnter" },
    { "nvim-lualine/lualine.nvim",       dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "luukvbaal/statuscol.nvim",        event = "BufEnter" },
    { 'Bekaboo/dropbar.nvim',            event = "BufEnter" },
    { "kdheepak/lazygit.nvim" },
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-node-modules.nvim', }
    },

    -- Global search and replace
    { 'nvim-pack/nvim-spectre' },

    -- LSP
    { 'neoclide/coc.nvim',     branch = 'release' },

    -- Themes
    {
      "0xstepit/flow.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
  },
})

