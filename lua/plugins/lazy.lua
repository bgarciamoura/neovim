require("autoload")

local lazy = require("lazy")

lazy.setup({
	{ "folke/which-key.nvim", event = "VeryLazy" },
  { "nvim-lua/plenary.nvim" },
  { "kdheepak/lazygit.nvim" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-tree/nvim-web-devicons" },
})
