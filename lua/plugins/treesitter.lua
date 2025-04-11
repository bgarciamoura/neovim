return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"typescript",
					"javascript",
					"tsx",
					"html",
					"css",
					"json",
					"yaml",
					"markdown",
					"bash",
					"scss",
					"kotlin",
					"java",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				sync_install = false,
				auto_install = true,
			})

			-- Forçar o recarregamento do highlighting
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					vim.cmd("TSEnable highlight")
				end,
			})
		end,
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
	},
}
