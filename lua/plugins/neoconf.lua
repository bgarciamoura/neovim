-- Este arquivo é carregado antes de qualquer configuração de LSP
-- O nome começa com "1-" para garantir prioridade na ordem de carregamento

return {
	{
		"folke/neoconf.nvim",
		priority = 2000, -- Prioridade extremamente alta
		lazy = false, -- Nunca carregue de forma preguiçosa
		config = function()
			-- Certificar-se que neoconf é configurado antes de qualquer outra coisa
			require("neoconf").setup({
				import = {
					vscode = true, -- importar configurações do .vscode/settings.json
					coc = true, -- importar configurações do coc-settings.json
				},
				plugins = {
					configls = {
						enabled = true,
					},
				},
			})
			-- Print de debug para verificar o carregamento
			print("neoconf.nvim configurado com sucesso")
		end,
	},
}
