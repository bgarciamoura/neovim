return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"zbirenbaum/copilot.lua", -- for copilot provider
	},
	build = "make",
	config = function()
		require("avante").setup({
			provider = "copilot",
			hints = { enabled = true },
		})
	end,
}
