-- Este módulo serve como um wrapper para garantir que neoconf seja inicializado apenas uma vez
-- e antes de qualquer configuração de servidor LSP
local M = {}

M.is_initialized = false

function M.ensure_initialized()
	if M.is_initialized then
		return true
	end

	local has_neoconf, neoconf = pcall(require, "neoconf")
	if not has_neoconf then
		print("ERRO: neoconf.nvim não está instalado ou não pode ser carregado")
		return false
	end

	if not neoconf.get().is_configured then
		-- print("Inicializando neoconf.nvim a partir do wrapper")
		neoconf.setup({
			import = {
				vscode = true,
				coc = true,
			},
			plugins = {
				configls = {
					enabled = true,
				},
			},
		})
	end

	M.is_initialized = true
	return true
end

-- Função para configurar lspconfig de forma segura
function M.setup_lspconfig(config_function)
	-- Garantir que neoconf esteja inicializado
	if not M.ensure_initialized() then
		print("AVISO: Não foi possível inicializar neoconf. LSP não será configurado.")
		return
	end

	-- Executar a função de configuração fornecida
	if type(config_function) == "function" then
		config_function()
	end
end

return M
