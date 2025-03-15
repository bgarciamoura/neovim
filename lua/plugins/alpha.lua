return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local handle = io.popen("echo $USER")
		local username = handle:read("*a"):gsub("\n", "")
		handle:close()

		-- ASCII ART (Alternando entre banners aleatórios)
		local banners = {
			{
				"██████╗  ██████╗ ██████╗ ██████╗ ███████╗",
				"╚════██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝",
				" █████╔╝██║     ██║   ██║██║  ██║█████╗  ",
				"██╔═══╝ ██║     ██║   ██║██║  ██║██╔══╝  ",
				"███████╗╚██████╗╚██████╔╝██████╔╝███████╗",
				"╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝",
			},
			{
				"oooooooooo.    .oooooo.    ",
				"`888'   `Y8b  d8P'  `Y8b   ",
				" 888     888 888           ",
				" 888oooo888' 888           ",
				" 888    `88b 888     ooooo ",
				" 888    .88P `88.    .88'  ",
				"o888bood8P'   `Y8bood8P'   ",
			},
			{
				"██████╗  ██████╗ ",
				"██╔══██╗██╔════╝ ",
				"██████╔╝██║  ███╗",
				"██╔══██╗██║   ██║",
				"██████╔╝╚██████╔╝",
				"╚═════╝  ╚═════╝ ",
			},
		}

		-- Escolher um banner aleatório
		math.randomseed(os.time())
		dashboard.section.header.val = banners[math.random(#banners)]

		-- Botões de ação
		dashboard.section.buttons.val = {
			dashboard.button("R", "  Restaurar Sessão", "<cmd>lua require('persistence').load()<CR>"),
			dashboard.button("e", "📄 Novo Arquivo", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "🔍 Buscar Arquivo", ":Telescope find_files<CR>"),
			dashboard.button("r", "📂 Arquivos Recentes", ":Telescope oldfiles<CR>"),
			dashboard.button("n", "📁 Abrir Neo-tree", ":Neotree toggle<CR>"),
			dashboard.button("s", "⚙️  Configurações", ":e $MYVIMRC<CR>"),
			dashboard.button("p", "📊 Relatório de Performance", ":PerformanceReport<CR>"),
			dashboard.button("q", "🚪 Sair", ":qa<CR>"),
		}

		-- Função para obter o tempo de inicialização do Neovim
		local function get_diagnostic_info()
			local lines = {}

			-- Obter estatísticas básicas do Lazy.nvim
			local lazy_stats = require("lazy").stats()
			table.insert(
				lines,
				string.format("🚀 Carregados %d plugins em %.2fms", lazy_stats.loaded, lazy_stats.startuptime)
			)

			-- Verificar se o módulo de diagnóstico está disponível
			local diagnostic_ok, diagnostic = pcall(require, "core.diagnostic")
			if diagnostic_ok and diagnostic.total_startup_time > 0 then
				-- Adicionar tempo de inicialização detalhado
				table.insert(
					lines,
					string.format("⚡ Tempo total de inicialização: %.2fms", diagnostic.total_startup_time)
				)

				-- Mostrar os 3 plugins mais lentos se disponíveis
				if next(diagnostic.plugin_times) ~= nil then
					-- Ordenar plugins por tempo
					local sorted_plugins = {}
					for plugin, time in pairs(diagnostic.plugin_times) do
						table.insert(sorted_plugins, { name = plugin, time = time })
					end

					table.sort(sorted_plugins, function(a, b)
						return a.time > b.time
					end)

					-- Adicionar título para plugins lentos
					if #sorted_plugins > 0 then
						table.insert(lines, "")
						table.insert(lines, "🐢 Plugins mais lentos:")

						-- Mostrar até 3 plugins lentos
						for i, plugin in ipairs(sorted_plugins) do
							if i > 3 then
								break
							end
							table.insert(
								lines,
								string.format("   • %s: %.2fms", plugin.name:gsub("^.*/", ""), plugin.time)
							)
						end
					end
				end

				-- Adicionar uso de memória
				local memory_stats = vim.loop.resident_set_memory()
				table.insert(lines, string.format("💾 Uso de memória: %.2f MB", memory_stats / 1024 / 1024))
			else
				-- Fallback básico se o diagnóstico não estiver disponível
				table.insert(lines, "⌨️  Feito com Neovim e ❤️")
			end

			-- Adicionar saudação ao usuário
			table.insert(lines, 1, "") -- Espaço em branco
			table.insert(lines, 1, "Olá, " .. username .. "! 👋")

			return lines
		end

		-- Seção com métricas do Neovim
		dashboard.section.footer.val = get_diagnostic_info()

		-- Configuração de cores e espaçamento
		dashboard.section.header.opts.hl = "Keyword"
		dashboard.section.buttons.opts.hl = "Function"
		dashboard.section.footer.opts.hl = "Comment"

		dashboard.opts.opts.noautocmd = true

		-- Espaçamento adicional para melhor legibilidade
		dashboard.config.layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		-- Aplicar tema e configuração ao Alpha
		alpha.setup(dashboard.config)

		-- Adicionar comando para atualizar métricas de performance no Alpha
		vim.api.nvim_create_user_command("AlphaUpdateStats", function()
			dashboard.section.footer.val = get_diagnostic_info()
			alpha.redraw()
		end, {})

		-- Atualizar estatísticas após a inicialização
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				-- Atualizar estatísticas após um breve atraso para garantir que todas as métricas estejam disponíveis
				vim.defer_fn(function()
					vim.cmd("AlphaUpdateStats")
				end, 100)
			end,
		})
	end,
}
