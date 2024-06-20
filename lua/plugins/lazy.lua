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

  -- icons
  { "DaikyXendo/nvim-material-icon" },

  -- colorschemes
  { "folke/tokyonight.nvim",               lazy = false,      priority = 1000, opts = {} },
  { "diegoulloao/neofusion.nvim",          lazy = false,      priority = 1000, opts = {} },
  { "rebelot/kanagawa.nvim",               lazy = false,      priority = 1000, opts = {} },
  { "scottmckendry/cyberdream.nvim",       lazy = false,      priority = 1000, opts = {} },
  { "Mofiqul/dracula.nvim",                lazy = false,      priority = 1000, opts = {} },
  { "Mofiqul/vscode.nvim",                 lazy = false,      priority = 1000, opts = {} },
  { "navarasu/onedark.nvim",               lazy = false,      priority = 1000, opts = {} },
  { "EdenEast/nightfox.nvim",              lazy = false,      priority = 1000, opts = {} },
  { "maxmx03/fluoromachine.nvim",          lazy = false,      priority = 1000, opts = {} },
  { "oxfist/night-owl.nvim",               lazy = false,      priority = 1000, opts = {} },
})
