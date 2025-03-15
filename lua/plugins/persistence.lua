return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	config = function()
		local persistence = require("persistence")

		-- Configuração básica
		persistence.setup({
			dir = vim.fn.stdpath("state") .. "/sessions/", -- Diretório para salvar sessões
			options = {
				"buffers", -- Buffers abertos
				"curdir", -- Diretório atual
				"tabpages", -- Abas abertas
				"winsize", -- Tamanho das janelas
				"globals", -- Variáveis globais (útil para manter estado entre sessões)
				"skiprtp", -- Pular verificação runtime path
			},
			-- Função pré-salvar que fecha plugins que podem causar problemas
			pre_save = function()
				-- Função para verificar se o buffer pertence ao Neo-tree
				local function is_neotree_buf(buf)
					local bufname = vim.api.nvim_buf_get_name(buf)
					return bufname:match("neo%-tree") ~= nil
				end

				-- Procurar por buffers do Neo-tree e fechá-los antes de salvar a sessão
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if is_neotree_buf(buf) then
						-- Verificar se o buffer é válido e está carregado
						if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
							-- Fechar o buffer
							vim.api.nvim_buf_delete(buf, { force = true })
						end
					end
				end

				-- Tentar fechar o Neo-tree usando o comando de plugin
				if vim.fn.exists(":Neotree") == 2 then
					vim.cmd("silent! Neotree close")
				end

				-- Outros plugins que podem causar problemas
				if vim.fn.exists(":TroubleClose") == 2 then
					vim.cmd("silent! TroubleClose")
				end

				if vim.fn.exists(":AlphaClose") == 2 then
					vim.cmd("silent! AlphaClose")
				end
			end,
		})

		-- Criar grupo de autocomandos para gerenciar sessões
		local session_group = vim.api.nvim_create_augroup("user-persistence", { clear = true })

		-- Eventos antes de salvar a sessão
		vim.api.nvim_create_autocmd("User", {
			group = session_group,
			pattern = "PersistenceSavePre",
			callback = function()
				-- Garantir que o Neo-tree esteja fechado
				if vim.fn.exists(":Neotree") == 2 then
					vim.cmd("silent! Neotree close")
				end
			end,
		})

		-- Eventos após carregar a sessão
		vim.api.nvim_create_autocmd("User", {
			group = session_group,
			pattern = "PersistenceLoadPost",
			callback = function()
				-- Esperar um pouco antes de reabrir o Neo-tree
				vim.defer_fn(function()
					-- Garantir que o Neo-tree não esteja já aberto
					if vim.fn.exists(":Neotree") == 2 then
						vim.cmd("silent! Neotree close")
						vim.cmd("silent! Neotree show")
					end
				end, 100) -- Pequeno atraso para garantir que o resto da sessão carregou
			end,
		})
	end,
}
