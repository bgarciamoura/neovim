local M = {}

-- Tabela para armazenar métricas de tempo
M.startup_times = {}
M.plugin_times = {}
M.total_startup_time = 0

-- Função para registrar o tempo de carregamento de plugin
M.register_plugin_time = function(plugin_name, load_time)
	M.plugin_times[plugin_name] = load_time
end

-- Função para registrar métricas de inicialização
M.register_startup_time = function(event_name, time)
	M.startup_times[event_name] = time
end

-- Função para medir o tempo de execução de uma função
M.measure = function(name, fn, ...)
	local start_time = vim.loop.hrtime()
	local result = { fn(...) }
	local end_time = vim.loop.hrtime()
	local duration = (end_time - start_time) / 1e6 -- Converter para milissegundos

	print(string.format("[Performance] %s: %.2f ms", name, duration))

	return unpack(result)
end

-- Função para gerar um relatório de performance
M.generate_report = function()
	local lines = {
		"# Relatório de Performance do Neovim",
		"",
		"## Tempo de Inicialização",
	}

	-- Adicionar tempos de inicialização
	for event, time in pairs(M.startup_times) do
		table.insert(lines, string.format("- %s: %.2f ms", event, time))
	end

	-- Adicionar tempo total
	table.insert(lines, string.format("- **Tempo Total**: %.2f ms", M.total_startup_time))

	-- Adicionar tempos de plugins
	table.insert(lines, "")
	table.insert(lines, "## Plugins mais lentos")

	-- Ordenar plugins por tempo de carregamento
	local sorted_plugins = {}
	for plugin, time in pairs(M.plugin_times) do
		table.insert(sorted_plugins, { name = plugin, time = time })
	end

	table.sort(sorted_plugins, function(a, b)
		return a.time > b.time
	end)

	-- Adicionar os 10 plugins mais lentos
	for i, plugin in ipairs(sorted_plugins) do
		if i > 10 then
			break
		end
		table.insert(lines, string.format("- %s: %.2f ms", plugin.name, plugin.time))
	end

	-- Adicionar estatísticas de memória
	table.insert(lines, "")
	table.insert(lines, "## Uso de Memória")

	local memory_stats = vim.loop.resident_set_memory()
	table.insert(lines, string.format("- Uso atual de memória: %.2f MB", memory_stats / 1024 / 1024))

	-- Criar um buffer e adicionar o relatório
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

	-- Abrir o buffer em uma nova janela
	vim.api.nvim_command("vsplit")
	vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)

	return buf
end

-- Patch do Lazy.nvim para capturar tempos de carregamento de plugins
M.setup_lazy_profiling = function()
	local lazy_ok, lazy = pcall(require, "lazy")
	if not lazy_ok then
		return
	end

	-- Monitorar tempo de carregamento de plugins
	local original_load = lazy.loader.load
	lazy.loader.load = function(plugin, ...)
		local start_time = vim.loop.hrtime()
		local result = original_load(plugin, ...)
		local end_time = vim.loop.hrtime()
		local duration = (end_time - start_time) / 1e6 -- Converter para milissegundos

		M.register_plugin_time(plugin, duration)

		return result
	end
end

-- Função para registrar o tempo total de inicialização
M.setup_startup_profiling = function()
	-- Registrar eventos VimEnter
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			local start_time = vim.g.start_time or vim.loop.hrtime()
			local now = vim.loop.hrtime()
			local startup_time = (now - start_time) / 1e6 -- Converter para milissegundos
			M.total_startup_time = startup_time
			M.register_startup_time("Total", startup_time)

			-- Opcionalmente, exibir tempos na barra de status
			if startup_time > 1000 then -- Se for mais de 1 segundo
				vim.notify(string.format("Neovim inicializado em %.2f ms (lento)", startup_time), "warn")
			else
				vim.notify(string.format("Neovim inicializado em %.2f ms", startup_time), "info")
			end
		end,
	})
end

-- Comandos Neovim para diagnóstico
M.setup_commands = function()
	-- Comando para gerar relatório
	vim.api.nvim_create_user_command("PerformanceReport", function()
		M.generate_report()
	end, {})

	-- Comando para medir um bloco de código
	vim.api.nvim_create_user_command("ProfileStart", function()
		vim.g.profile_start_time = vim.loop.hrtime()
		vim.notify("Iniciando perfil...", "info")
	end, {})

	vim.api.nvim_create_user_command("ProfileEnd", function()
		if vim.g.profile_start_time then
			local end_time = vim.loop.hrtime()
			local duration = (end_time - vim.g.profile_start_time) / 1e6
			vim.notify(string.format("Tempo decorrido: %.2f ms", duration), "info")
			vim.g.profile_start_time = nil
		else
			vim.notify("Perfil não iniciado. Use :ProfileStart primeiro.", "error")
		end
	end, {})
end

-- Função principal para inicializar o módulo de diagnóstico
M.setup = function()
	-- Registrar o tempo de início
	vim.g.start_time = vim.loop.hrtime()

	-- Configurar monitoramento de plugins
	M.setup_lazy_profiling()

	-- Configurar medição de tempo de inicialização
	M.setup_startup_profiling()

	-- Configurar comandos
	M.setup_commands()

	-- Retornar o módulo para ser reutilizado
	return M
end

return M
