return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		vim.cmd([[highlight IblIndent guifg=#313131 gui=nocombine]])

		require("ibl").setup({
			indent = {
				char = "▏", -- Pode ser alterado para "⦙", "┆", "┊"
				highlight = "IblIndent", -- Nome do destaque que vamos personalizar
			},
		})
	end,
}
