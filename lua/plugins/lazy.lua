require("autoload")

local lazy = require("lazy")

lazy.setup({
	{ "folke/which-key.nvim", event = "VeryLazy" },
  { "nvim-lua/plenary.nvim" },
  { "kdheepak/lazygit.nvim" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-tree/nvim-web-devicons" },
  { "andrew-george/telescope-themes" },
  { "nvim-telescope/telescope.nvim", tag = '0.1.6', dependencies = { "nvim-lua/plenary.nvim" } },
  { "brenoprata10/nvim-highlight-colors" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { "MunifTanjim/nui.nvim" } },

  -- icons
  { "DaikyXendo/nvim-material-icon" },

  -- colorschemes
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
  { "diegoulloao/neofusion.nvim", lazy = false, priority = 1000, opts = {} },
})
