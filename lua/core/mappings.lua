local function map(mode, target_keys, command, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, target_keys, command, options)
end

map("n", "<C-a>", ":keepjumps normal! ggVG<CR>", { desc = "Select all text using control+a" })
map("n", "<A-k>", "<CMD>resize +10<CR>", { desc = "Increase window size to up" })
map("n", "<A-j>", "<CMD>resize  -10<CR>", { desc = "Increase window size to down" })
map("n", "<A-h>", "<CMD>vertical resize +10<CR>", { desc = "Increase window size to left" })
map("n", "<A-l>", "<CMD>vertical resize -10<CR>", { desc = "Increase window size to right" })
-- map("n", "<C-J>", "<C-w>j", { desc = "Move the cursor to the bottom window" })
-- map("n", "<C-H>", "<C-w>h", { desc = "Move the cursor to the left window" })
-- map("n", "<C-L>", "<C-w>l", { desc = "Move the cursor to the right window" })
-- map("n", "<C-K>", "<C-w>k", { desc = "Move the cursor to the top window" })
map("n", "<leader>cc", ':keepjumps normal! ggVG "*yG<CR>', { desc = "Copy the entire file to system clipboard" })
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split the screen verticaly" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split the screen horizontaly" })
map("n", "<leader>qo", "<C-w>o", { desc = "Close all splitted buffers but the active one" })
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Open or close Neotree" })
map("n", "<leader>jj", ":Neotree focus<CR>", { desc = "Focus on Neotree buffer" })

map("n", "<leader>r", ":so %<CR>", { desc = "Reload configuration without restart nvim" })
map("n", "<leader>q", ":qa!<CR>", { desc = "Close all windows and exit from Neovim with <leader> and q" })

-- Move lines up and down
map("n", "<C-j>", ":m .+1<CR>==", { desc = "Move the current line down" })
map("n", "<C-k>", ":m .-2<CR>==", { desc = "Move the current line up" })

-- Move visual block up and down
map("x", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move the visual block down" })
map("x", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move the visual block up" })

-- Mapear Ctrl+V para colar no Neovim (usando o clipboard do sistema)
map("i", "<C-v>", "<C-r>+", { desc = "Colar no modo de inserção" })
map("n", "<C-v>", '"+p', { desc = "Colar no modo normal" })
map("v", "<C-v>", '"+p', { desc = "Colar no modo visual" })
map("c", "<C-v>", "<C-r>+", { desc = "Colar no modo comando" })

-- Mapear Ctrl+C para copiar no Neovim (usando o clipboard do sistema)
map("v", "<leader>c", '"+y', { desc = "Copiar no modo visual" })
map("n", "<leader>c", '"+y', { desc = "Copiar no modo normal" })
map("c", "<leader>c", '"+y', { desc = "Copiar no modo comando" })
map("i", "<leader>c", '"+y', { desc = "Copiar no modo de inserção" })

-- Git Signs
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Git Blame na linha atual" })
map("n", "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", { desc = "Próxima alteração" })
map("n", "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Alteração anterior" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Adicionar alteração ao staging" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reverter alteração" })

-- Persistence
map("n", "<leader>ss", [[<cmd>lua require("persistence").load()<CR>]], { noremap = true, silent = true }) -- Restaurar última sessão
map("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<CR>]], { noremap = true, silent = true }) -- Restaurar sessão mais recente
map("n", "<leader>sd", [[<cmd>lua require("persistence").stop()<CR>]], { noremap = true, silent = true }) -- Desativar salvamento de sessão na sessão atual

-- Navegar entre buffers
map("n", "<S-l>", ":bnext<CR>", { desc = "Próximo buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader>bd", ":bd<CR>", { desc = "Fechar buffer atual" })

-- Melhor navegação por palavras (evita parar em símbolos)
map("n", "w", "wzz", { desc = "Mover para a próxima palavra e centralizar" })
map("n", "b", "bzz", { desc = "Mover para a palavra anterior e centralizar" })
map("n", "n", "nzz", { desc = "Próxima ocorrência e centralizar" })
map("n", "N", "Nzz", { desc = "Ocorrência anterior e centralizar" })

-- Rolar a tela sem mover o cursor
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll para cima e centralizar" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll para baixo e centralizar" })

-- Manter o cursor na posição ao juntar linhas
map("n", "J", "mzJ`z", { desc = "Juntar linha sem mover cursor" })

-- Adicionar novas linhas sem entrar no modo de inserção
map("n", "<leader>o", "o<Esc>", { desc = "Nova linha abaixo" })
map("n", "<leader>O", "O<Esc>", { desc = "Nova linha acima" })

-- Salvar e fechar rapidamente
map("n", "<C-s>", ":w<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>x", ":x<CR>", { desc = "Salvar e sair" })
map("n", "<leader>Q", ":q!<CR>", { desc = "Sair sem salvar" })

-- Movimentação rápida no modo de inserção
map("i", "<C-h>", "<Left>", { desc = "Mover cursor para a esquerda" })
map("i", "<C-l>", "<Right>", { desc = "Mover cursor para a direita" })
map("i", "<C-j>", "<Down>", { desc = "Mover cursor para baixo" })
map("i", "<C-k>", "<Up>", { desc = "Mover cursor para cima" })

-- Indentar no modo visual e manter seleção
map("v", "<", "<gv", { desc = "Diminuir indentação" })
map("v", ">", ">gv", { desc = "Aumentar indentação" })

-- Substituir seleção sem copiar para o clipboard
map("v", "p", '"_dP', { desc = "Substituir texto sem afetar clipboard" })

-- Abrir Terminal integrado
map("n", "<leader>t", ":split | terminal<CR>", { desc = "Abrir terminal no split" })
map("n", "<leader>vt", ":vsplit | terminal<CR>", { desc = "Abrir terminal em vertical" })

-- Selecionar e substituir
map("n", "<leader>sr", ":%s//g<Left><Left>", { desc = "Selecionar e substituir no arquivo" })
map("v", "<leader>sr", "y:%s/<C-r>0//g<Left><Left>", { desc = "Selecionar e substituir na seleção" })
map("n", "<leader>sw", ":Spectre<CR>", { desc = "Selecionar e substituir no workspace" })

-- Neotest
map("n", "<leader>js", "<cmd>lua require('neotest').run.stop()<cr>", { desc = "Parar execução de testes" })
map("n", "<leader>jr", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Executar testes" })
map(
	"n",
	"<leader>jf",
	"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
	{ desc = "Executar testes do arquivo" }
)
map("n", "<leader>jo", "<cmd>lua require('neotest').output.open()<cr>", { desc = "Abrir saída de testes" })
map(
	"n",
	"<leader>ju",
	"<cmd>lua require('neotest').summary.toggle()<cr>",
	{ desc = "Alternar visibilidade do resumo de testes" }
)
map(
	"n",
	"<leader>jp",
	"<cmd>lua require('neotest').jump.prev({status = 'failed'})<cr>",
	{ desc = "Ir para o próximo teste falho" }
)
map(
	"n",
	"<leader>jn",
	"<cmd>lua require('neotest').jump.next({status = 'failed'})<cr>",
	{ desc = "Ir para o teste anterior falho" }
)

-- Selecionar uma palavra para a esquerda do cursor
map("n", "gw", "viw", { desc = "Selecionar palavra para a esquerda" })

-- Selecionar uma palavra para a direita do cursor
map("n", "ge", "vaw", { desc = "Selecionar palavra para a direita" })

-- Selecionar texto entre aspas
map("n", "gq", 'vi"', { desc = "Selecionar texto entre aspas" })

-- Selecionar texto entre parênteses
map("n", "gQ", "vi)", { desc = "Selecionar texto entre parênteses" })

-- Selecionar texto entre colchetes
map("n", "g[", "vi[", { desc = "Selecionar texto entre colchetes" })

-- Selecionar texto entre chaves
map("n", "g{", "vi{", { desc = "Selecionar texto entre chaves" })

-- Incrementar e decrementar números
map("n", "<C-A>", "<C-a>", { desc = "Incrementar número" })
map("n", "<C-x>", "<C-x>", { desc = "Decrementar número" })
