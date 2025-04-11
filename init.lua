-- Iniciar medição de tempo (coloque isso o mais no topo possível)
vim.g.start_time = vim.loop.hrtime()

-- Carregar o módulo de diagnóstico de performance
local diagnostic_ok, diagnostic = pcall(require, "core.diagnostic")
if diagnostic_ok then
	diagnostic.setup()
end

-- Carregar opções
require("core.options")

-- Carregar o gerenciador de plugins
require("config.lazy")

-- Garantir inicialização do neoconf antes de qualquer coisa relacionada a LSP
require("core.neoconf-wrapper").ensure_initialized()

-- Configuração LSP
require("config.lspconfig")

-- Tema
require("themes.morta")

-- vim.cmd.colorscheme("catppuccin")
