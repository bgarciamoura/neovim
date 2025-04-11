local neoconf_wrapper = require("core.neoconf-wrapper")

return {
	-- Neoconf deve vir primeiro com alta prioridade
	{
		"folke/neoconf.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			neoconf_wrapper.ensure_initialized()
		end,
	},

	-- Plugin principal do LSP
	{
		"neovim/nvim-lspconfig",
		priority = 900,
		dependencies = { "folke/neoconf.nvim" },
		config = function()
			neoconf_wrapper.setup_lspconfig(function()
				local lspconfig = require("lspconfig")

				-- Configurações específicas de LSP para este plugin
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
			end)
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
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"folke/neoconf.nvim",
		},
		config = function()
			-- Garantir que neoconf está inicializado antes de configurar LSP
			neoconf_wrapper.ensure_initialized()

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

			-- Configurar os servidores LSP do Mason após a instalação
			neoconf_wrapper.setup_lspconfig(function()
				require("mason-lspconfig").setup_handlers({
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
				})
			end)
		end,
	},
}
