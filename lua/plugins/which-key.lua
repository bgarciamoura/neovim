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
          nav = false,     -- Desativa atalhos padrão para navegação
          z = false,       -- Desativa atalhos padrão para comandos "z"
          g = false,       -- Desativa atalhos padrão para comandos "g"
        },
      },
    })

    wk.add({
      { "<leader>b",  group = "Buffers",                        desc = "Buffers" },
      { "<leader>bd", ":bd<CR>",                                desc = "Fechar Buffer Atual" },
      { "<leader>e",  ":Neotree toggle<CR>",                    desc = "Abrir/Fechar NeoTree" },
      { "<leader>f",  group = "Telescope" },
      { "<leader>fb", ":Telescope buffers<CR>",                 desc = "Listar Buffers" },
      { "<leader>ff", ":Telescope find_files<CR>",              desc = "Buscar Arquivos" },
      { "<leader>fg", ":Telescope live_grep<CR>",               desc = "Buscar Texto no Projeto" },
      { "<leader>fh", ":Telescope help_tags<CR>",               desc = "Buscar na Ajuda" },
      { "<leader>g",  group = "Gitsigns" },
      { "<leader>gb", "<cmd>Gitsigns blame_line<CR>",           desc = "Git Blame na Linha Atual" },
      { "<leader>gn", "<cmd>Gitsigns next_hunk<CR>",            desc = "Próxima Alteração" },
      { "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>",            desc = "Alteração Anterior" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>",           desc = "Reverter Alteração" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>",           desc = "Adicionar Alteração ao Staging" },
      { "<leader>l",  group = "LSP" },
      { "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>",      desc = "Renomear Símbolo" },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Ações de Código" },
      { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>",  desc = "Ir para Definição" },
      { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>",      desc = "Formatar Código" },
      { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>",       desc = "Mostrar Documentação" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>",  desc = "Referências" },
      { "<leader>m",  group = "Render Markdown" },
      { "<leader>mp", "<cmd>MarkdownPreview<CR>",               desc = "Abrir Preview de Markdown" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<CR>",           desc = "Parar Preview de Markdown" },
      { "<leader>n",  group = "Null-LS" },
      { "<leader>nf", "<cmd>lua vim.lsp.buf.format()<CR>",      desc = "Formatar Código" },
      { "<leader>qo", "<C-w>o",                                 desc = "Fechar Outras Janelas" },
      {
        "<leader>ql",
        "<cmd>lua require('persistence').load({ last = true })<CR>",
        desc = "Restaurar Sessão Mais Recente",
      },
      { "<leader>s",  group = "Persistence" },
      {
        "<leader>sd",
        "<cmd>lua require('persistence').stop()<CR>",
        desc = "Desativar Salvamento de Sessão",
      },
      { "<leader>sh", ":split<CR>",                                 desc = "Dividir Janela Horizontalmente" },
      { "<leader>sr", ":%s//g<Left><Left>",                         desc = "Substituir no Arquivo" },
      { "<leader>ss", "<cmd>lua require('persistence').load()<CR>", desc = "Restaurar Última Sessão" },
      { "<leader>sv", ":vsplit<CR>",                                desc = "Dividir Janela Verticalmente" },
      { "<leader>sw", ":Spectre<CR>",                               desc = "Substituir no Workspace" },
      { "<leader>t",  group = "Terminal" },
      { "<leader>t",  ":split | terminal<CR>",                      desc = "Abrir Terminal" },
      { "<leader>vt", ":vsplit | terminal<CR>",                     desc = "Abrir Terminal Vertical" },
    })
  end,
}
