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
vim.defer_fn(function()
	vim.cmd.colorscheme("morta")
end, 10)

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Verificar se a fonte Nerd está instalada corretamente
		local has_nerd_font = vim.fn.system("fc-list | grep -i nerd") ~= ""
		if not has_nerd_font then
			vim.notify("Nerd Font não foi detectada! Os ícones podem não aparecer corretamente", vim.log.levels.WARN)
		end

		-- Verificar se o Treesitter está funcionando
		local ts_ok, _ = pcall(require, "nvim-treesitter")
		if not ts_ok then
			vim.notify("Treesitter não está carregado corretamente!", vim.log.levels.ERROR)
		end

		-- Verificar configuração de tema
		local theme_loaded = vim.g.colors_name
		vim.notify("Tema carregado: " .. (theme_loaded or "nenhum"), vim.log.levels.INFO)
	end,
})
