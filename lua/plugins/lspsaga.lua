return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({
			lightbulb = {
				enable = false,
			},
			symbol_in_winbar = { enable = true }, -- Exibe caminho do código no topo
			ui = {
				border = "rounded",
				max_width = 0.9, -- Aumenta a largura para 90% da tela
				max_height = 0.8, -- Aumenta a altura para 80% da tela
			},
			finder = {
				keys = { edit = "<CR>" },
				max_height = 0.7, -- Ajusta a altura do Finder
				max_width = 0.8, -- Ajusta a largura do Finder
			},
			hover = {
				max_width = 0.7, -- Ajusta a largura da documentação hover
				max_height = 0.6, -- Ajusta a altura da documentação hover
			},
			rename = {
				max_width = 0.5, -- Ajusta a largura da janela de renomeação
			},
			code_action = {
				max_height = 0.5, -- Ajusta a altura da janela de Code Actions
				max_width = 0.6, -- Ajusta a largura da janela de Code Actions
			},
		})
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
}
