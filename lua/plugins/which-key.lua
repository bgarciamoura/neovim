return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")

		wk.setup({
			plugins = {
				presets = {
					operators = false,
					motions = false,
					text_objects = false,
					windows = false,
					nav = false,
					z = false,
					g = false,
				},
			},
			icons = {
				breadcrumb = "»",
				separator = "➜",
				group = "+",
			},
			win = { -- usando 'win' ao invés de 'window' (que está obsoleto)
				border = "rounded",
				padding = { 2, 2, 2, 2 },
			},
			layout = {
				height = { min = 4, max = 25 },
				width = { min = 20, max = 50 },
				spacing = 3,
			},
		})

		wk.add({
			-- Mapeamentos básicos em modo normal
			{ "<C-a>", ":keepjumps normal! ggVG<CR>", desc = "Selecionar todo o texto" },
			{ "<C-s>", ":w<CR>", desc = "Salvar arquivo" },
			{ "<C-q>", ":q<CR>", desc = "Sair" },
			{ "ZZ", ":x<CR>", desc = "Salvar e sair" },
			{ "<leader>o", "o<Esc>", desc = "Nova linha abaixo (sem inserção)" },
			{ "<leader>O", "O<Esc>", desc = "Nova linha acima (sem inserção)" },

			-- Movimentos e centralização
			{ "w", "wzz", desc = "Mover para próxima palavra e centralizar" },
			{ "b", "bzz", desc = "Mover para palavra anterior e centralizar" },
			{ "n", "nzz", desc = "Próxima ocorrência e centralizar" },
			{ "N", "Nzz", desc = "Ocorrência anterior e centralizar" },
			{ "<C-u>", "<C-u>zz", desc = "Scroll para cima e centralizar" },
			{ "<C-d>", "<C-d>zz", desc = "Scroll para baixo e centralizar" },
			{ "J", "mzJ`z", desc = "Juntar linha sem mover cursor" },

			-- Mover linhas
			{ "<C-j>", ":m .+1<CR>==", desc = "Mover linha para baixo" },
			{ "<C-k>", ":m .-2<CR>==", desc = "Mover linha para cima" },

			-- Navegação entre buffers
			{ "<S-l>", ":bnext<CR>", desc = "Próximo buffer" },
			{ "<S-h>", ":bprevious<CR>", desc = "Buffer anterior" },

			-- Redimensionar janelas
			{ "<A-k>", "<CMD>resize +10<CR>", desc = "Aumentar altura da janela" },
			{ "<A-j>", "<CMD>resize -10<CR>", desc = "Diminuir altura da janela" },
			{ "<A-h>", "<CMD>vertical resize +10<CR>", desc = "Aumentar largura da janela" },
			{ "<A-l>", "<CMD>vertical resize -10<CR>", desc = "Diminuir largura da janela" },

			-- Seleção avançada
			{ "gw", "viw", desc = "Selecionar palavra atual" },
			{ "ge", "vaw", desc = "Selecionar palavra e espaço" },
			{ "gq", 'vi"', desc = "Selecionar entre aspas" },
			{ "gQ", "vi)", desc = "Selecionar entre parênteses" },
			{ "g[", "vi[", desc = "Selecionar entre colchetes" },
			{ "g{", "vi{", desc = "Selecionar entre chaves" },

			-- [F] ARQUIVOS E BUSCA
			{ "<leader>f", group = "Arquivos/Busca" },
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Buscar arquivos" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Buscar texto no projeto" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Listar buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Buscar na documentação" },
			{ "<leader>fs", "<cmd>Telescope git_status<CR>", desc = "Arquivos modificados (Git)" },
			{ "<leader>fc", "<cmd>Telescope git_commits<CR>", desc = "Buscar commits" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Arquivos recentes" },
			{ "<leader>ft", "<cmd>Telescope treesitter<CR>", desc = "Símbolos Treesitter" },
			{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Listar atalhos de teclado" },
			{ "<leader>fp", "<cmd>Telescope projects<CR>", desc = "Projetos recentes" },

			-- [E] EXPLORADOR (NEO-TREE)
			{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Alternar Explorer" },
			{ "<leader>ef", "<cmd>Neotree focus<CR>", desc = "Focar Explorer" },
			{ "<leader>eb", "<cmd>Neotree buffers<CR>", desc = "Exibir buffers" },
			{ "<leader>eg", "<cmd>Neotree git_status<CR>", desc = "Exibir Git status" },

			-- [G] GIT
			{ "<leader>g", group = "Git" },
			{ "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "Git Blame na linha atual" },
			{ "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", desc = "Próxima alteração" },
			{ "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", desc = "Alteração anterior" },
			{ "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Adicionar alteração ao staging" },
			{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reverter alteração" },
			{ "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "Ver diferenças" },
			{ "<leader>gB", "<cmd>Telescope git_branches<CR>", desc = "Listar branches" },
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Listar commits" },
			{ "<leader>gS", "<cmd>Telescope git_status<CR>", desc = "Git status" },
			{ "<leader>gg", "<cmd>LazyGit<CR>", desc = "Abrir LazyGit" },

			-- [L] LSP E CÓDIGOS
			{ "<leader>l", group = "LSP/Código" },
			{ "<leader>lr", "<cmd>Lspsaga rename<CR>", desc = "Renomear símbolo" },
			{ "<leader>la", "<cmd>Lspsaga code_action<CR>", desc = "Ações de código" },
			{ "<leader>ld", "<cmd>Lspsaga peek_definition<CR>", desc = "Visualizar definição" },
			{ "<leader>lD", "<cmd>Lspsaga goto_definition<CR>", desc = "Ir para definição" },
			{ "<leader>lh", "<cmd>Lspsaga hover_doc<CR>", desc = "Mostrar documentação" },
			{ "<leader>lp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Erro anterior" },
			{ "<leader>ln", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Próximo erro" },
			{ "<leader>lx", "<cmd>Lspsaga show_diagnostics<CR>", desc = "Exibir erros no arquivo" },
			{ "<leader>lt", "<cmd>Lspsaga term_toggle<CR>", desc = "Terminal flutuante" },
			{ "<leader>ls", "<cmd>Lspsaga outline<CR>", desc = "Exibir estrutura do código" },
			{ "<leader>lf", "<cmd>Lspsaga finder<CR>", desc = "Localizar referências" },
			{ "<leader>lT", "<cmd>Lspsaga goto_type_definition<CR>", desc = "Ir para definição de tipo" },
			{ "<leader>li", "<cmd>LspInfo<CR>", desc = "Informações do LSP" },

			-- [LC] LEETCODE
			{ "<leader>lc", group = "LeetCode" },
			{ "<leader>lcl", "<cmd>LeetCode list<CR>", desc = "Listar questões" },
			{ "<leader>lco", "<cmd>LeetCode open<CR>", desc = "Abrir questão" },
			{ "<leader>lcs", "<cmd>LeetCode submit<CR>", desc = "Enviar solução" },
			{ "<leader>lct", "<cmd>LeetCode test<CR>", desc = "Testar solução" },

			-- [T] TERMINAL
			{ "<leader>t", group = "Terminal" },
			{ "<leader>tt", ":split | terminal<CR>", desc = "Abrir terminal horizontal" },
			{ "<leader>tv", ":vsplit | terminal<CR>", desc = "Abrir terminal vertical" },
			{ "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal flutuante" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal horizontal" },
			{ "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", desc = "Terminal Python" },
			{ "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", desc = "Terminal Node.js" },

			-- [D] DEBUG
			{ "<leader>d", group = "Debug" },
			{ "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Alterar breakpoint" },
			{ "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", desc = "Continuar" },
			{ "<leader>do", "<cmd>lua require'dap'.step_over()<CR>", desc = "Passo sobre" },
			{ "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", desc = "Passo dentro" },
			{ "<leader>ds", "<cmd>lua require'dap'.step_out()<CR>", desc = "Passo fora" },
			{ "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", desc = "Abrir REPL" },
			{ "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", desc = "Alternar UI" },
			{ "<leader>dx", "<cmd>lua require'dap'.terminate()<CR>", desc = "Encerrar" },
			{ "<leader>dC", "<cmd>lua require'dap'.clear_breakpoints()<CR>", desc = "Limpar breakpoints" },
			{ "<leader>de", "<cmd>lua require'dapui'.eval()<CR>", desc = "Avaliar expressão" },

			-- [J] TESTES (NEOTEST)
			{ "<leader>j", group = "Testes" },
			{ "<leader>js", "<cmd>lua require('neotest').run.stop()<CR>", desc = "Parar execução de testes" },
			{ "<leader>jr", "<cmd>lua require('neotest').run.run()<CR>", desc = "Executar teste atual" },
			{
				"<leader>jf",
				"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
				desc = "Executar testes do arquivo",
			},
			{ "<leader>jo", "<cmd>lua require('neotest').output.open()<CR>", desc = "Abrir saída de testes" },
			{ "<leader>ju", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Alternar resumo de testes" },
			{
				"<leader>jp",
				"<cmd>lua require('neotest').jump.prev({status = 'failed'})<CR>",
				desc = "Ir para teste falho anterior",
			},
			{
				"<leader>jn",
				"<cmd>lua require('neotest').jump.next({status = 'failed'})<CR>",
				desc = "Ir para próximo teste falho",
			},
			{
				"<leader>jw",
				"<cmd>lua require('neotest').run.run({ jestCommand = 'pnpx jest --watch ' })<CR>",
				desc = "Jest Watch",
			},
			{ "<leader>jkt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Executar teste atual" },
			{
				"<leader>jkf",
				"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
				desc = "Executar testes do arquivo",
			},

			-- [C] CÓDIGO/CLIPBOARD
			{ "<leader>c", group = "Código/Clipboard" },
			{ "<leader>cc", '"+y', desc = "Copiar para clipboard" },
			{ "<leader>cA", ':keepjumps normal! ggVG "*yG<CR>', desc = "Copiar arquivo inteiro" },
			{ "<leader>cf", "<cmd>lua require('conform').format()<CR>", desc = "Formatar código" },
			{ "<leader>cg", "<cmd>Neogen<CR>", desc = "Gerar documentação" },
			{ "<leader>cd", "<cmd>Lspsaga hover_doc<CR>", desc = "Mostrar documentação" },

			-- [S] SESSÕES/BUSCA/SPECTRE
			{ "<leader>s", group = "Sessões/Busca" },
			{ "<leader>ss", "<cmd>lua require('persistence').load()<CR>", desc = "Restaurar última sessão" },
			{
				"<leader>sl",
				"<cmd>lua require('persistence').load({ last = true })<CR>",
				desc = "Restaurar sessão mais recente",
			},
			{ "<leader>sd", "<cmd>lua require('persistence').stop()<CR>", desc = "Desativar salvamento de sessão" },
			{ "<leader>sr", "<cmd>Spectre<CR>", desc = "Abrir Spectre" },
			{
				"<leader>sw",
				"<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
				desc = "Buscar palavra atual",
			},
			{ "<leader>sf", "<cmd>lua require('spectre').open_file_search()<CR>", desc = "Buscar no arquivo atual" },
			{ "<leader>sp", "<cmd>Telescope projects<CR>", desc = "Projetos" },
			{ "<leader>sg", "<cmd>Telescope live_grep<CR>", desc = "Buscar texto" },
			{ "<leader>sl", "<cmd>SessionList<CR>", desc = "Listar e carregar sessões" },
			{ "<leader>sS", "<cmd>SessionSaveAs<CR>", desc = "Salvar sessão com nome" },
			{ "<leader>sx", "<cmd>SessionDelete<CR>", desc = "Excluir sessão" },

			-- [W] JANELAS (WINDOWS)
			{ "<leader>w", group = "Janelas" },
			{ "<leader>ws", ":split<CR>", desc = "Dividir horizontalmente" }, -- Mudei de wh para ws para evitar conflito
			{ "<leader>wv", ":vsplit<CR>", desc = "Dividir verticalmente" },
			{ "<leader>wc", "<C-w>c", desc = "Fechar janela atual" },
			{ "<leader>wo", "<C-w>o", desc = "Fechar outras janelas" },
			{ "<leader>wj", "<C-w>j", desc = "Ir para janela abaixo" },
			{ "<leader>wk", "<C-w>k", desc = "Ir para janela acima" },
			{ "<leader>wh", "<C-w>h", desc = "Ir para janela à esquerda" },
			{ "<leader>wl", "<C-w>l", desc = "Ir para janela à direita" },
			{ "<leader>w=", "<C-w>=", desc = "Equalizar janelas" },
			{ "<leader>w+", ":resize +5<CR>", desc = "Aumentar altura" },
			{ "<leader>w-", ":resize -5<CR>", desc = "Diminuir altura" },
			{ "<leader>w>", ":vertical resize +5<CR>", desc = "Aumentar largura" },
			{ "<leader>w<", ":vertical resize -5<CR>", desc = "Diminuir largura" },

			-- [B] BUFFERS
			{ "<leader>b", group = "Buffers" },
			{ "<leader>bb", "<cmd>Telescope buffers<CR>", desc = "Listar buffers" },
			{ "<leader>bd", ":bd<CR>", desc = "Fechar buffer atual" },
			{ "<leader>bn", ":bnext<CR>", desc = "Próximo buffer" },
			{ "<leader>bp", ":bprevious<CR>", desc = "Buffer anterior" },
			{ "<leader>bf", ":bfirst<CR>", desc = "Primeiro buffer" },
			{ "<leader>bl", ":blast<CR>", desc = "Último buffer" },
			{ "<leader>bc", ":%bd|e#<CR>", desc = "Fechar todos os buffers exceto o atual" },

			-- [R] RECARREGAR/RENDER
			{ "<leader>r", group = "Recarregar/Render" },
			{ "<leader>rr", ":so %<CR>", desc = "Recarregar arquivo atual" },
			{ "<leader>rc", ":luafile %<CR>", desc = "Recarregar configuração Lua" },
			{ "<leader>rm", "<cmd>lua require('render-markdown').render()<CR>", desc = "Renderizar Markdown" },

			-- [A] IA (AVANTE/AI)
			{ "<leader>a", group = "IA/AI" },
			{ "<leader>aa", "<cmd>Avante<CR>", desc = "Abrir Avante" },
			{ "<leader>ac", "<cmd>CopilotPanel<CR>", desc = "Painel Copilot" },
			{ "<leader>ae", "<cmd>CopilotEnable<CR>", desc = "Ativar Copilot" },
			{ "<leader>ad", "<cmd>CopilotDisable<CR>", desc = "Desativar Copilot" },

			-- [X] SAIR/FECHAR
			{ "<leader>x", group = "Sair/Fechar" },
			{ "<leader>xx", ":x<CR>", desc = "Salvar e sair" },
			{ "<leader>xq", ":q<CR>", desc = "Sair" },
			{ "<leader>xQ", ":q!<CR>", desc = "Forçar saída" },
			{ "<leader>xs", ":w<CR>", desc = "Salvar" },
			{ "<leader>xa", ":qa<CR>", desc = "Sair de todos" },
			{ "<leader>xA", ":qa!<CR>", desc = "Forçar saída de todos" },

			-- [M] MÚLTIPLOS CURSORES
			{ "<leader>m", group = "Múltiplos Cursores" },
			{
				"<leader>mn",
				"<cmd>lua require('multicursor-nvim').matchAddCursor(1)<CR>",
				desc = "Adicionar cursor na próxima",
			},
			{
				"<leader>mp",
				"<cmd>lua require('multicursor-nvim').matchAddCursor(-1)<CR>",
				desc = "Adicionar cursor na anterior",
			},
			{
				"<leader>ms",
				"<cmd>lua require('multicursor-nvim').matchSkipCursor(1)<CR>",
				desc = "Pular cursor na próxima",
			},
			{
				"<leader>mS",
				"<cmd>lua require('multicursor-nvim').matchSkipCursor(-1)<CR>",
				desc = "Pular cursor na anterior",
			},
			{
				"<leader>ma",
				"<cmd>lua require('multicursor-nvim').matchAllAddCursors()<CR>",
				desc = "Adicionar em todas",
			},
			{ "<leader>mx", "<cmd>lua require('multicursor-nvim').deleteCursor()<CR>", desc = "Deletar cursor atual" },
			{ "<leader>mr", "<cmd>lua require('multicursor-nvim').restoreCursors()<CR>", desc = "Restaurar cursores" },

			-- [DC] DEVCONTAINERS
			{ "<leader>dc", group = "DevContainers" },
			{ "<leader>dcb", "<cmd>DevcontainerBuild<CR>", desc = "Construir contêiner" },
			{ "<leader>dcr", "<cmd>DevcontainerBuildAndRun<CR>", desc = "Construir e executar" },
			{ "<leader>dcu", "<cmd>DevcontainerComposeUp<CR>", desc = "Compose Up" },
			{ "<leader>dcd", "<cmd>DevcontainerComposeDown<CR>", desc = "Compose Down" },
			{ "<leader>dcs", "<cmd>DevcontainerStartAttached<CR>", desc = "Iniciar contêiner (anexado)" },
			{ "<leader>dce", "<cmd>DevcontainerExec<CR>", desc = "Executar comando no contêiner" },
			{ "<leader>dco", "<cmd>DevcontainerOpenExplorer<CR>", desc = "Abrir explorador no contêiner" },

			-- [DK] DOCKER
			{ "<leader>dk", group = "Docker" },
			{ "<leader>dki", "<cmd>DockerImages<CR>", desc = "Listar imagens" },
			{ "<leader>dkc", "<cmd>DockerContainers<CR>", desc = "Listar contêineres" },
			{ "<leader>dkr", "<cmd>DockerRun<CR>", desc = "Executar contêiner" },
			{ "<leader>dku", "<cmd>DockerComposeUp<CR>", desc = "Docker Compose Up" },
			{ "<leader>dka", "<cmd>DockerAttach<CR>", desc = "Anexar a um contêiner" },

			-- Mapeamentos para modos específicos
			{
				mode = "v", -- Modo Visual
				{ "<", "<gv", desc = "Desindentar e manter seleção" },
				{ ">", ">gv", desc = "Indentar e manter seleção" },
				{ "<C-j>", ":m '>+1<CR>gv=gv", desc = "Mover bloco visual para baixo" },
				{ "<C-k>", ":m '<-2<CR>gv=gv", desc = "Mover bloco visual para cima" },
				{ "p", '"_dP', desc = "Colar sem copiar o substituído" },
				{ "<leader>c", '"+y', desc = "Copiar para clipboard" },
				{ "<leader>s", "y/<C-r>0<CR>", desc = "Buscar seleção" },
				{ "<leader>sr", "y:%s/<C-r>0//g<Left><Left>", desc = "Substituir seleção" },
			},

			{
				mode = "i", -- Modo Inserção
				{ "<C-h>", "<Left>", desc = "Mover cursor para esquerda" },
				{ "<C-l>", "<Right>", desc = "Mover cursor para direita" },
				{ "<C-j>", "<Down>", desc = "Mover cursor para baixo" },
				{ "<C-k>", "<Up>", desc = "Mover cursor para cima" },
				{ "<C-v>", "<C-r>+", desc = "Colar do clipboard" },
				{ "<C-s>", "<Esc>:w<CR>a", desc = "Salvar" },
			},

			{
				mode = "c", -- Modo Comando
				{ "<C-v>", "<C-r>+", desc = "Colar do clipboard" },
			},

			{
				mode = "t", -- Modo Terminal
				{ "<Esc>", "<C-\\><C-n>", desc = "Sair do modo terminal" },
				{ "<C-h>", "<C-\\><C-n><C-w>h", desc = "Ir para janela à esquerda" },
				{ "<C-j>", "<C-\\><C-n><C-w>j", desc = "Ir para janela abaixo" },
				{ "<C-k>", "<C-\\><C-n><C-w>k", desc = "Ir para janela acima" },
				{ "<C-l>", "<C-\\><C-n><C-w>l", desc = "Ir para janela à direita" },
			},

			-- [K] KOTLIN SPRING
			{ "<leader>k", group = "Kotlin/Spring" },
			{ "<leader>ks", "<cmd>lua require('spring-boot').start()<cr>", desc = "Iniciar aplicação Spring Boot" },
			{
				"<leader>kr",
				"<cmd>lua require('spring-boot').restart()<cr>",
				desc = "Reiniciar aplicação Spring Boot",
			},
			{ "<leader>kl", "<cmd>lua require('spring-boot').showLogs()<cr>", desc = "Mostrar logs Spring Boot" },
		})
	end,
}
