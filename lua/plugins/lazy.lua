require("autoload")

local lazy = require("lazy")

lazy.setup({
  { "folke/which-key.nvim",              event = "VeryLazy" },
  { "nvim-lua/plenary.nvim" },
  { "kdheepak/lazygit.nvim" },
  { "nvim-treesitter/nvim-treesitter",   build = ":TSUpdate" },
  { "nvim-tree/nvim-web-devicons" },
  { "andrew-george/telescope-themes" },
  { "nvim-telescope/telescope.nvim",     tag = '0.1.6',                                   dependencies = { "nvim-lua/plenary.nvim" } },
  { "brenoprata10/nvim-highlight-colors" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-neo-tree/neo-tree.nvim",       branch = "v3.x",                                 dependencies = { "MunifTanjim/nui.nvim" } },
  { "nvim-lualine/lualine.nvim",         dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "iamcco/markdown-preview.nvim",
    event = "VeryLazy",
    build = function()
      vim.fn
          ["mkdp#util#install"]()
    end,
    ft = { "markdown" }
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  { "olimorris/persisted.nvim",            lazy = false },
  { "neoclide/coc.nvim",                   branch = "release" },
  { "mattn/emmet-vim",                     lazy = true },
  { "Exafunction/codeium.vim",             event = "BufEnter" },
  { "yamatsum/nvim-cursorline",            event = "BufEnter" },
  { "luukvbaal/statuscol.nvim",            event = "BufEnter" },
  { 'Bekaboo/dropbar.nvim',                event = "BufEnter" },
  { "nanozuki/tabby.nvim",                 dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- icons
  { "DaikyXendo/nvim-material-icon" },

  -- colorschemes
  { "folke/tokyonight.nvim",               lazy = false,                                    priority = 1000, opts = {} },
  { "diegoulloao/neofusion.nvim",          lazy = false,                                    priority = 1000, opts = {} },
  { "rebelot/kanagawa.nvim",               lazy = false,                                    priority = 1000, opts = {} },
  { "scottmckendry/cyberdream.nvim",       lazy = false,                                    priority = 1000, opts = {} },
  { "dracula/vim",                         as = "dracula",                                  lazy = false,    priority = 1000 },
  { "Mofiqul/vscode.nvim",                 lazy = false,                                    priority = 1000, opts = {} },
  { "navarasu/onedark.nvim",               lazy = false,                                    priority = 1000, opts = {} },
  { "EdenEast/nightfox.nvim",              lazy = false,                                    priority = 1000, opts = {} },
  { "maxmx03/fluoromachine.nvim",          lazy = false,                                    priority = 1000, opts = {} },
  { "oxfist/night-owl.nvim",               lazy = false,                                    priority = 1000, opts = {} },
  { "catppuccin/nvim",                     name = "catppuccin",                             priority = 1000 },
  { "sho-87/kanagawa-paper.nvim",          lazy = false,                                    priority = 1000, opts = {}, },
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require 'nordic'
          .load()
    end
  },
  { "rose-pine/neovim",            name = "rose-pine", lazy = false,   priority = 1000, opts = {} },
  {
    'maxmx03/fluoromachine.nvim',
    lazy = true,
    lazy = false,
    priority = 1000,
    config = function()
      local fm = require 'fluoromachine'

      fm.setup {
        glow = true,
        theme = 'fluoromachine',
        transparent = true,
      }
    end
  },
  { "bluz71/vim-nightfly-colors",  name = "nightfly",  lazy = false,   priority = 1000 },
  { 'marko-cerovac/material.nvim', name = "material",  lazy = false,   priority = 1000, opts = {} },
  { "shaunsingh/moonlight.nvim",   lazy = false,       priority = 1000 },

})
