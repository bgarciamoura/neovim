-- lua/plugins/kotlin.lua
return {
	-- Plugin para suporte ao Kotlin
	{
		"udalov/kotlin-vim", -- Syntax highlighting para Kotlin
		ft = { "kotlin" },
	},
	{
		"mfussenegger/nvim-jdtls", -- JDT Language Server (para Java e Kotlin)
		ft = { "java", "kotlin" },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Configuração para o Kotlin Language Server
				kotlin_language_server = {
					settings = {
						kotlin = {
							compiler = {
								jvm = {
									target = "17", -- Versão do JDK
								},
							},
							completion = {
								snippets = {
									enabled = true,
								},
							},
							linting = {
								enabled = true,
							},
							formatOnSave = true,
							import = {
								enableOptimization = true,
							},
						},
					},
				},
			},
		},
	},
}
