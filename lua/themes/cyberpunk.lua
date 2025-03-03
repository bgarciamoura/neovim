-- cyberpunk.lua

-- Definindo a nova paleta de cores com escolhas mais suaves e cores ajustadas:
local colors = {
  bg          = "#121212", -- fundo principal (mais suave que o preto puro)
  fg          = "#dcdcdc", -- texto e elementos primários (off-white, menos agressivo que o branco puro)
  gray        = "#6e6e6e", -- detalhes e divisórias (cinza mais discreto)
  neon_green  = "#96ff00", -- informações e destaques alternativos (verde neon)
  neon_orange = "#ff6f00", -- nova cor contrastante, substituindo o amarelo neon
  accent1     = "#ff007c", -- acento adicional: Neon Pink
  accent2     = "#00d9ff", -- acento adicional: Neon Blue
}

-- Função para aplicar os highlights do tema
local function set_highlights()
  -- Highlights gerais
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.gray, italic = true })
  vim.api.nvim_set_hl(0, "Error", { fg = colors.bg, bg = colors.neon_orange, bold = true })
  vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.neon_orange })
  vim.api.nvim_set_hl(0, "InfoMsg", { fg = colors.neon_green })
  vim.api.nvim_set_hl(0, "String", { fg = colors.neon_green })

  -- Highlights para números de linha
  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.gray, bg = colors.bg })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.neon_orange, bg = "#1a1a1a", bold = true })

  -- Destaques para Treesitter
  vim.api.nvim_set_hl(0, "@function", { fg = colors.accent2, bold = true })
  vim.api.nvim_set_hl(0, "@keyword", { fg = colors.neon_orange, bold = true })
  vim.api.nvim_set_hl(0, "@string", { fg = colors.neon_green })

  -- Configurações para o LSPSaga (exemplo)
  vim.api.nvim_set_hl(0, "LSPSagaBorder", { fg = colors.neon_orange })
  vim.api.nvim_set_hl(0, "LSPSagaHoverNormal", { fg = colors.fg, bg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "LspSagaHoverBorder", { fg = colors.accent2, bg = colors.bg }) -- antes usava neon_cyan
  vim.api.nvim_set_hl(0, "LspSagaCodeActionBorder", { fg = colors.neon_orange, bg = colors.bg })
  vim.api.nvim_set_hl(0, "LspSagaCodeActionContent", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "LspSagaFinderSelection", { fg = colors.neon_green, bg = colors.gray })
  vim.api.nvim_set_hl(0, "LspSagaRenamePrompt", { fg = colors.accent1, bg = colors.bg })
  vim.api.nvim_set_hl(0, "LspSagaDiagnosticHeader", { fg = colors.neon_orange, bg = colors.bg })
  vim.api.nvim_set_hl(0, "LspSagaDiagnosticBorder", { fg = colors.accent1, bg = colors.bg })
  vim.api.nvim_set_hl(0, "LspSagaSignatureActiveParameter", { fg = colors.neon_green, bg = colors.bg })

  -- Configurações para o Neo-tree (exemplo)
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#ebff00" })

  -- Grupos de sintaxe
  vim.api.nvim_set_hl(0, "Constant", { fg = colors.accent2 })
  vim.api.nvim_set_hl(0, "Identifier", { fg = colors.neon_green })
  vim.api.nvim_set_hl(0, "Statement", { fg = colors.neon_orange })
  vim.api.nvim_set_hl(0, "Type", { fg = colors.accent1 })
  vim.api.nvim_set_hl(0, "PreProc", { fg = colors.accent2 })
  vim.api.nvim_set_hl(0, "Special", { fg = colors.neon_orange, bold = true })
  vim.api.nvim_set_hl(0, "Underlined", { fg = colors.accent1, underline = true })

  -- Linha de status
  vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = "#1a1a1a", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.gray, bg = colors.bg })

  -- Divisor vertical
  vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.gray, bg = colors.bg })

  -- Título e marcadores de TODO
  vim.api.nvim_set_hl(0, "Title", { fg = colors.neon_orange, bg = colors.bg, bold = true })
  vim.api.nvim_set_hl(0, "Todo", { fg = colors.accent1, bg = colors.bg, italic = true })

  -- Modo Visual
  vim.api.nvim_set_hl(0, "Visual", { bg = "#1e1e1e" })

  -- Pesquisa
  vim.api.nvim_set_hl(0, "Search", { fg = colors.bg, bg = colors.neon_orange, bold = true })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.bg, bg = colors.accent1, bold = true })

  -- Popup Menu
  vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = "#1e1e1e" })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.bg, bg = colors.accent2 })

  -- Diferenças (Diff)
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = colors.neon_green, bg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = colors.accent2, bg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = colors.neon_orange, bg = "#1a1a1a" })

  -- Texto dobrado e coluna de dobramento
  vim.api.nvim_set_hl(0, "Folded", { fg = colors.gray, bg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "FoldColumn", { fg = colors.gray, bg = colors.bg })
end

-- Configuração do Lualine com tema Cyberpunk
local function setup_lualine()
  require('lualine').setup {
    options = {
      theme = {
        normal = {
          a = { fg = colors.bg, bg = colors.neon_green, gui = 'bold' },
          b = { fg = colors.fg, bg = colors.gray },
          c = { fg = colors.fg, bg = colors.bg },
        },
        insert = {
          a = { fg = colors.bg, bg = colors.accent2, gui = 'bold' },
        },
        visual = {
          a = { fg = colors.bg, bg = colors.neon_orange, gui = 'bold' },
        },
        replace = {
          a = { fg = colors.bg, bg = colors.accent1, gui = 'bold' },
        },
        inactive = {
          a = { fg = colors.fg, bg = colors.bg },
        },
      },
      section_separators = { left = '', right = '' },
      component_separators = { left = ' ', right = ' ' },
    }
  }
end

-- Função principal que aplica as configurações do tema e dos plugins
local function setup()
  set_highlights()
  setup_lualine()
  -- Outras configurações de plugins podem ser adicionadas aqui
end

-- Executa a configuração
setup()
