return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")

		wk.setup({
			plugins = {
				presets = {
					operators = false, -- Desativa atalhos padrão para operadores
					motions = false, -- Desativa atalhos padrão para movimentações
					text_objects = false, -- Desativa atalhos padrão para objetos de texto
					windows = false, -- Desativa atalhos padrão para janelas
					nav = false, -- Desativa atalhos padrão para navegação
					z = false, -- Desativa atalhos padrão para comandos "z"
					g = false, -- Desativa atalhos padrão para comandos "g"
				},
			},
		})

		wk.add({
			-- Buffers
			{ "<leader>b", group = "Buffers" },
			{ "<leader>bd", ":bd<CR>", desc = "Fechar Buffer Atual" },
			{ "<leader>bl", ":Telescope buffers<CR>", desc = "Listar Buffers" },

			-- NeoTree
			{ "<leader>e", ":Neotree toggle<CR>", desc = "Abrir/Fechar NeoTree" },
			{ "<leader>jj", ":Neotree focus<CR>", desc = "Focar no NeoTree" },

			-- LSP
			{ "<leader>l", group = "LSP" },
			{ "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Renomear Símbolo" },
			{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Ações de Código" },
			{ "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Ir para Definição" },
			{ "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "Formatar Código" },
			{ "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Mostrar Documentação" },
			{ "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Referências" },
			{ "<leader>ls", "<cmd>Lspsaga outline<CR>", desc = "Abrir Outline" },
			{ "<leader>lo", "<cmd>Lspsaga hover_doc<CR>", desc = "Abrir Documentação Hover" },

			-- Git Signs
			{ "<leader>g", group = "Git" },
			{ "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "Git Blame na Linha Atual" },
			{ "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", desc = "Próxima Alteração" },
			{ "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", desc = "Alteração Anterior" },
			{ "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Adicionar Alteração ao Staging" },
			{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reverter Alteração" },
			{ "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "Ver Diferenças" },

			-- LazyGit
			{ "<leader>lg", "<cmd>LazyGit<CR>", desc = "Abrir LazyGit" },

			-- Formatação e Linting
			{ "<leader>cf", "<cmd>lua require('conform').format()<CR>", desc = "Formatar Código" },

			-- Persistence (Sessões)
			{ "<leader>s", group = "Sessões" },
			{ "<leader>ss", "<cmd>lua require('persistence').load()<CR>", desc = "Restaurar Última Sessão" },
			{
				"<leader>ql",
				"<cmd>lua require('persistence').load({ last = true })<CR>",
				desc = "Restaurar Sessão Mais Recente",
			},
			{ "<leader>sd", "<cmd>lua require('persistence').stop()<CR>", desc = "Desativar Salvamento de Sessão" },

			-- Neotest
			{ "<leader>j", group = "Neotest" },
			{ "<leader>js", "<cmd>lua require('neotest').run.stop()<CR>", desc = "Parar Execução de Testes" },
			{ "<leader>jr", "<cmd>lua require('neotest').run.run()<CR>", desc = "Executar Testes" },
			{
				"<leader>jf",
				"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
				desc = "Executar Testes do Arquivo",
			},
			{ "<leader>jo", "<cmd>lua require('neotest').output.open()<CR>", desc = "Abrir Saída de Testes" },
			{ "<leader>ju", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Alternar Resumo de Testes" },

			-- LazyGit
			{ "<leader>lg", "<cmd>LazyGit<CR>", desc = "Abrir LazyGit" },

			-- Terminal
			{ "<leader>t", group = "Terminal" },
			{ "<leader>t", ":split | terminal<CR>", desc = "Abrir Terminal" },
			{ "<leader>vt", ":vsplit | terminal<CR>", desc = "Abrir Terminal Vertical" },

			-- Janela e Split
			{ "<leader>sh", ":split<CR>", desc = "Dividir Janela Horizontalmente" },
			{ "<leader>sv", ":vsplit<CR>", desc = "Dividir Janela Verticalmente" },
			{ "<leader>qo", "<C-w>o", desc = "Fechar Outras Janelas" },

			-- Movimentação Rápida
			{ "<C-j>", ":m .+1<CR>==", desc = "Mover Linha para Baixo" },
			{ "<C-k>", ":m .-2<CR>==", desc = "Mover Linha para Cima" },
			{ "<C-a>", ":keepjumps normal! ggVG<CR>", desc = "Selecionar Tudo" },

			-- Salvar e Fechar
			{ "<C-s>", ":w<CR>", desc = "Salvar Arquivo" },
			{ "<leader>x", ":x<CR>", desc = "Salvar e Sair" },
			{ "<leader>Q", ":q!<CR>", desc = "Sair sem Salvar" },

			-- Movimentação no Modo Inserção
			{ "<C-h>", "<Left>", desc = "Mover Cursor para a Esquerda" },
			{ "<C-l>", "<Right>", desc = "Mover Cursor para a Direita" },
			{ "<C-j>", "<Down>", desc = "Mover Cursor para Baixo" },
			{ "<C-k>", "<Up>", desc = "Mover Cursor para Cima" },

			-- Indentação
			{ "<", "<gv", desc = "Diminuir Indentação" },
			{ ">", ">gv", desc = "Aumentar Indentação" },

			-- Copiar e Colar
			{ "<leader>cc", ':keepjumps normal! ggVG "*yG<CR>', desc = "Copiar Todo o Arquivo" },
			{ "<leader>c", '"+y', desc = "Copiar para o Clipboard" },
			{ "<C-v>", '"+p', desc = "Colar do Clipboard" },

			-- Melhor Navegação por Palavras
			{ "w", "wzz", desc = "Mover para a Próxima Palavra e Centralizar" },
			{ "b", "bzz", desc = "Mover para a Palavra Anterior e Centralizar" },
			{ "n", "nzz", desc = "Próxima Ocorrência e Centralizar" },
			{ "N", "Nzz", desc = "Ocorrência Anterior e Centralizar" },

			-- Rolar a Tela sem Mover o Cursor
			{ "<C-u>", "<C-u>zz", desc = "Scroll para Cima e Centralizar" },
			{ "<C-d>", "<C-d>zz", desc = "Scroll para Baixo e Centralizar" },

			-- Avante (IA)
			{ "<leader>av", "<cmd>Avante<CR>", desc = "Abrir Avante" },

			-- LeetCode
			{ "<leader>lc", "<cmd>LeetCode list<CR>", desc = "Listar Questões do LeetCode" },
			{ "<leader>lco", "<cmd>LeetCode open<CR>", desc = "Abrir Questão" },
			{ "<leader>lcs", "<cmd>LeetCode submit<CR>", desc = "Enviar Solução" },
		})
	end,
}
