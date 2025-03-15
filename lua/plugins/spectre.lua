return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Spectre",
	keys = {},
	config = function()
		require("spectre").setup({
			color_devicons = true,
			live_update = true, -- Atualiza automaticamente enquanto digita
			result_padding = "│ ",
			line_sep_start = "────────────────────────────────────────",
			line_sep = "────────────────────────────────────────",
			default = {
				find = {
					cmd = "rg",
					options = { "--hidden", "--glob=!node_modules/*", "--glob=!dist/*" },
				},
			},
		})
	end,
}
