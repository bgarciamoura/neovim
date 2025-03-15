return {
	-- Suporte geral para TypeScript
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		opts = {
			settings = {
				-- Configurações para manipular importações
				tsserver_file_preferences = {
					importModuleSpecifierPreference = "relative",
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
				},
				-- Inlay hints (tipos inline)
				tsserver_format_options = {
					allowIncompleteCompletions = true,
					allowRenameOfImportPath = true,
				},
			},
		},
	},
}
