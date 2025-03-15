return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" }, -- Dependência necessária
	cmd = "Telescope",
	keys = {},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				layout_config = {
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
				mappings = {
					i = {},
				},
			},
			pickers = {
				find_files = {
					hidden = true, -- Mostra arquivos ocultos
				},
				live_grep = {
					only_sort_text = true,
				},
			},
		})
	end,
}
