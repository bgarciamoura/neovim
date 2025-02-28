-- cyberpunk_soft.lua

-- Definição da paleta de cores
local colors = {
  bg          = "#121212", -- Fundo suave
  fg          = "#ffffff",
  gray        = "#80858b",
  neon_yellow = "#ebff00",
  neon_green  = "#96ff00",
  neon_pink   = "#ff00ff",
  neon_cyan   = "#00ffff",
  dark_gray   = "#2a2a2a",
  soft_blue   = "#3a3a80",
  soft_purple = "#5a4e7a",
  soft_orange = "#d28e00",
}

local function set_highlights()
  local api = vim.api

  -- Highlights básicos
  api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  api.nvim_set_hl(0, "CursorLine", { bg = colors.dark_gray })
  api.nvim_set_hl(0, "Visual", { bg = colors.soft_blue })
  api.nvim_set_hl(0, "Comment", { fg = colors.gray, italic = true })
  api.nvim_set_hl(0, "String", { fg = colors.neon_green })
  api.nvim_set_hl(0, "Identifier", { fg = colors.fg })
  api.nvim_set_hl(0, "Keyword", { fg = colors.neon_pink, italic = true })
  api.nvim_set_hl(0, "Function", { fg = colors.neon_cyan, bold = true })
  api.nvim_set_hl(0, "Type", { fg = colors.soft_orange })
  api.nvim_set_hl(0, "Constant", { fg = colors.neon_yellow })
  api.nvim_set_hl(0, "Operator", { fg = colors.soft_purple })

  -- Destaques para Diff
  api.nvim_set_hl(0, "DiffAdd", { bg = "#223322", fg = colors.neon_green })
  api.nvim_set_hl(0, "DiffChange", { bg = "#333322", fg = colors.neon_yellow })
  api.nvim_set_hl(0, "DiffDelete", { bg = "#442222", fg = colors.neon_pink })
  api.nvim_set_hl(0, "DiffText", { bg = "#555533", fg = colors.fg })

  -- Destaques para menus e popups
  api.nvim_set_hl(0, "Pmenu", { bg = colors.dark_gray, fg = colors.fg })
  api.nvim_set_hl(0, "PmenuSel", { bg = colors.soft_blue, fg = colors.fg })
  api.nvim_set_hl(0, "PmenuSbar", { bg = colors.dark_gray })
  api.nvim_set_hl(0, "PmenuThumb", { bg = colors.neon_yellow })

  -- Integração com Treesitter
  api.nvim_set_hl(0, "@function", { fg = colors.neon_cyan, bold = true })
  api.nvim_set_hl(0, "@variable", { fg = colors.fg })
  api.nvim_set_hl(0, "@keyword", { fg = colors.neon_pink, italic = true })
  api.nvim_set_hl(0, "@string", { fg = colors.neon_green })
  api.nvim_set_hl(0, "@comment", { fg = colors.gray, italic = true })
  api.nvim_set_hl(0, "@type", { fg = colors.soft_orange })

  -- Outros elementos da interface
  api.nvim_set_hl(0, "LineNr", { fg = colors.gray })
  api.nvim_set_hl(0, "CursorLineNr", { fg = colors.neon_yellow })
  api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = colors.gray })
  api.nvim_set_hl(0, "StatusLineNC", { fg = colors.gray, bg = colors.bg })

  -- Mensagens de erro e aviso
  api.nvim_set_hl(0, "ErrorMsg", { fg = colors.bg, bg = colors.neon_yellow, bold = true })
  api.nvim_set_hl(0, "WarningMsg", { fg = colors.bg, bg = colors.neon_pink, bold = true })

  -- Integração com LSPSaga
  api.nvim_set_hl(0, "LspSagaBorder", { fg = colors.soft_blue, bg = colors.bg })
  api.nvim_set_hl(0, "LspSagaHoverBorder", { fg = colors.neon_cyan, bg = colors.bg })
  api.nvim_set_hl(0, "LspSagaCodeActionBorder", { fg = colors.neon_yellow, bg = colors.bg })
  api.nvim_set_hl(0, "LspSagaCodeActionContent", { fg = colors.fg, bg = colors.bg })
  api.nvim_set_hl(0, "LspSagaFinderSelection", { fg = colors.neon_green, bg = colors.dark_gray })
  api.nvim_set_hl(0, "LspSagaRenamePrompt", { fg = colors.neon_pink, bg = colors.bg })
  api.nvim_set_hl(0, "LspSagaDiagnosticHeader", { fg = colors.neon_yellow, bg = colors.bg })
  api.nvim_set_hl(0, "LspSagaDiagnosticBorder", { fg = colors.neon_pink, bg = colors.bg })
  api.nvim_set_hl(0, "LspSagaSignatureActiveParameter", { fg = colors.neon_green, bg = colors.bg })
end

-- Aplica os highlights
set_highlights()

-- Configuração de integração com o lualine
local function setup_lualine()
  require('lualine').setup {
    options = {
      theme = {
        normal = {
          a = { fg = colors.bg, bg = colors.neon_green, gui = "bold" },
          b = { fg = colors.fg, bg = colors.dark_gray },
          c = { fg = colors.fg, bg = colors.bg },
        },
        insert = {
          a = { fg = colors.bg, bg = colors.neon_yellow, gui = "bold" },
        },
        visual = {
          a = { fg = colors.bg, bg = colors.neon_pink, gui = "bold" },
        },
        command = {
          a = { fg = colors.bg, bg = colors.neon_cyan, gui = "bold" },
        }
      },
      section_separators = { left = '', right = '' },
      component_separators = { left = '|', right = '|' },
    },
  }
end

pcall(setup_lualine)

return {
  set_highlights = set_highlights,
  colors = colors,
}
