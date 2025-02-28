-- cyberpunk_light.lua

-- Definição da paleta de cores para a versão light
local colors = {
  bg          = "#f5f5f5", -- Fundo principal claro
  fg          = "#202020", -- Texto principal escuro
  gray        = "#80858b",
  neon_yellow = "#ebff00",
  neon_green  = "#96ff00",
  neon_pink   = "#ff00ff",
  neon_cyan   = "#00ffff",
  light_gray  = "#dcdcdc",
  soft_blue   = "#7a9cc6",
  soft_purple = "#a380c6",
  soft_orange = "#d28e00",
}

local function set_highlights()
  local api = vim.api

  -- Highlights básicos
  api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  api.nvim_set_hl(0, "CursorLine", { bg = colors.light_gray })
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
  api.nvim_set_hl(0, "DiffAdd", { bg = "#e0f2d0", fg = colors.neon_green })
  api.nvim_set_hl(0, "DiffChange", { bg = "#f0e5c0", fg = colors.neon_yellow })
  api.nvim_set_hl(0, "DiffDelete", { bg = "#f2d0d0", fg = colors.neon_pink })
  api.nvim_set_hl(0, "DiffText", { bg = "#ececec", fg = colors.fg })

  -- Menus e popups
  api.nvim_set_hl(0, "Pmenu", { bg = colors.light_gray, fg = colors.fg })
  api.nvim_set_hl(0, "PmenuSel", { bg = colors.soft_blue, fg = colors.fg })
  api.nvim_set_hl(0, "PmenuSbar", { bg = colors.light_gray })
  api.nvim_set_hl(0, "PmenuThumb", { bg = colors.neon_yellow })

  -- Integração com Treesitter
  api.nvim_set_hl(0, "@function", { fg = colors.neon_cyan, bold = true })
  api.nvim_set_hl(0, "@variable", { fg = colors.fg })
  api.nvim_set_hl(0, "@keyword", { fg = colors.neon_pink, italic = true })
  api.nvim_set_hl(0, "@string", { fg = colors.neon_green })
  api.nvim_set_hl(0, "@comment", { fg = colors.gray, italic = true })
  api.nvim_set_hl(0, "@type", { fg = colors.soft_orange })

  -- Números de linha e StatusLine
  api.nvim_set_hl(0, "LineNr", { fg = colors.light_gray })
  api.nvim_set_hl(0, "CursorLineNr", { fg = colors.neon_yellow })
  api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = colors.light_gray })
  api.nvim_set_hl(0, "StatusLineNC", { fg = colors.gray, bg = colors.bg })

  -- Mensagens de erro e aviso
  api.nvim_set_hl(0, "ErrorMsg", { fg = colors.bg, bg = colors.neon_yellow, bold = true })
  api.nvim_set_hl(0, "WarningMsg", { fg = colors.bg, bg = colors.neon_pink, bold = true })
end

-- Aplica os highlights
set_highlights()

-- Integração com o lualine
local function setup_lualine()
  require('lualine').setup {
    options = {
      theme = {
        normal = {
          a = { fg = colors.bg, bg = colors.neon_green, gui = "bold" },
          b = { fg = colors.fg, bg = colors.light_gray },
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
