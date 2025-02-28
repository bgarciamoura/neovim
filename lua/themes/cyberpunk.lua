-- cyberpunk.lua

-- Definição da paleta de cores
local colors = {
  bg          = "#000000",
  fg          = "#ffffff",
  gray        = "#80858b",
  neon_yellow = "#ebff00",
  neon_green  = "#96ff00",
  neon_pink   = "#ff00ff",
  neon_cyan   = "#00ffff",
  dark_gray   = "#2a2a2a",
}

-- Função para aplicar os highlights
local function set_highlights()
  local api = vim.api

  -- Highlights básicos
  api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  api.nvim_set_hl(0, "Comment", { fg = colors.gray, italic = true })
  api.nvim_set_hl(0, "String", { fg = colors.neon_green })
  api.nvim_set_hl(0, "Identifier", { fg = colors.fg })
  api.nvim_set_hl(0, "Keyword", { fg = colors.neon_pink, italic = true })
  api.nvim_set_hl(0, "Function", { fg = colors.neon_cyan, bold = true })

  -- Integração com Treesitter (grupos comuns)
  api.nvim_set_hl(0, "@function", { fg = colors.neon_cyan, bold = true })
  api.nvim_set_hl(0, "@variable", { fg = colors.fg })
  api.nvim_set_hl(0, "@keyword", { fg = colors.neon_pink, italic = true })
  api.nvim_set_hl(0, "@string", { fg = colors.neon_green })
  api.nvim_set_hl(0, "@comment", { fg = colors.gray, italic = true })

  -- Outros grupos de destaque
  api.nvim_set_hl(0, "ErrorMsg", { fg = colors.bg, bg = colors.neon_yellow, bold = true })
  api.nvim_set_hl(0, "WarningMsg", { fg = colors.bg, bg = colors.neon_pink, bold = true })
  api.nvim_set_hl(0, "Visual", { bg = colors.dark_gray })
end

-- Aplica os highlights
set_highlights()

-- Integração com o lualine (exemplo de configuração do tema)
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

-- Verifica se o lualine está instalado e configura-o
pcall(setup_lualine)

return {
  set_highlights = set_highlights,
  colors = colors,
}
