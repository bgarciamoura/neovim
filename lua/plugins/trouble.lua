local vim = vim

return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({
				signs = {
					error = "🔥", -- Ícone personalizado para erros
					warning = "⚠️",
					-- hint = "💡",
					hint = "",
					information = "ℹ️",
				},
			})
		end,
	},
}
