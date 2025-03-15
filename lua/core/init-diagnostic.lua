-- Módulo para adicionar diagnóstico de inicialização ao init.lua
local M = {}

function M.setup()
	-- Carregar e configurar o módulo de diagnóstico
	vim.g.start_time = vim.loop.hrtime()

	-- Adicionar este código ao seu init.lua existente (geralmente no início do arquivo)
	local diagnostic_code = [[
  -- Carrega o módulo de diagnóstico de performance
  local diagnostic_ok, diagnostic = pcall(require, "core.diagnostic")
  if diagnostic_ok then
    diagnostic.setup()
  end
  ]]

	-- Gerar instruções para o usuário
	print("Para habilitar o diagnóstico de inicialização, adicione o seguinte código ao início do seu init.lua:")
	print(diagnostic_code)

	-- Explicar os comandos disponíveis
	print("\nApós adicionar, você terá acesso aos seguintes comandos:")
	print("- :PerformanceReport - Gera um relatório detalhado de performance")
	print("- :ProfileStart - Inicia a medição de tempo para um bloco de código")
	print("- :ProfileEnd - Finaliza a medição e exibe o tempo decorrido")

	return diagnostic_code
end

return M
