return {
	-- Plugin principal do LSP
	{ "neovim/nvim-lspconfig" },

	-- Mason: Gerenciador de LSPs
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
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
					"yamllint", -- Linting para yaml
					"taplo", -- Linting para toml
					"xmllint", -- Linting para xml
					"prisma-language-server", -- Linting para prisma
					"dotenv-linter", -- Linting para env
				},
			})
		end,
	},
}
