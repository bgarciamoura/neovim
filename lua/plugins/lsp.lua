return {
	-- Detectar configuração do projeto e ajustar automaticamente
	{
		"folke/neoconf.nvim",
		opts = {
			import = {
				vscode = true, -- importar configurações do .vscode/settings.json
				coc = true, -- importar configurações do coc-settings.json
			},
			plugins = {
				configls = {
					enabled = true,
					-- Validação para package.json, tsconfig.json, etc.
				},
			},
		},
	},
	-- Plugin principal do LSP
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.jdtls.setup({
				settings = {
					java = {
						configuration = {
							updateBuildConfiguration = "automatic",
						},
						maven = {
							downloadSources = true,
						},
						implementationsCodeLens = {
							enabled = true,
						},
						referencesCodeLens = {
							enabled = true,
						},
						format = {
							enabled = true,
						},
					},
				},
			})

			lspconfig.groovyls.setup({})
		end,
	},

	-- Mason: Gerenciador de LSPs
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
	},

	-- Mason-LSPConfig: Integra Mason com o LSP
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls", "html", "cssls", "jsonls", "lua_ls" },
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"stylelint",
					"jsonlint",
					"stylua",
					"biome", -- Ferramenta para linting mais rápida que o eslint
					"prettierd", -- Formatação com Prettier mais rápida
					"stylua", -- Formatação para Lua
					"shfmt", -- Formatação para Shell Scripts
					"luacheck", -- Linting para Lua
					"htmlhint", -- Linting para HTML
					"markdownlint", -- Linting para Markdown
					"hadolint", -- Linting para Dockerfile
					"taplo", -- Linting para toml
					"prisma-language-server", -- Linting para prisma
					-- "ktfmt", -- Formatação para Kotlin
					"ktlint", -- Linting para Kotlin
					"kotlin_language_server", -- LSP para Kotlin
					"jdtls", -- LSP para Java e Kotlin
					"groovyls", -- LSP para Groovy e Gradle
				},
				auto_update = true, -- Atualiza automaticamente as ferramentas instaladas
				run_on_start = true, -- Instala automaticamente ao iniciar o Neovim
				integrations = {
					["mason-lspconfig"] = true,
					["mason-null-ls"] = false,
					["mason-nvim-dap"] = false,
				},
			})
		end,
	},
}
