return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = {
				"biome", -- Ferramenta para linting mais rápida que o eslint
				"prettierd", -- Formatação com Prettier mais rápida
				"stylua", -- Formatação para Lua
				"shfmt", -- Formatação para Shell Scripts
				"css-beautify", -- Formatação para CSS
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
			auto_update = true, -- Atualiza automaticamente as ferramentas instaladas
			run_on_start = true, -- Instala automaticamente ao iniciar o Neovim
			integrations = {
				["mason-lspconfig"] = true,
				["mason-null-ls"] = false,
				["mason-nvim-dap"] = false,
			},
		})
	end,
}
