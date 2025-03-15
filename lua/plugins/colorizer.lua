return {
  "norcalli/nvim-colorizer.lua",
  event = "BufReadPost",
  config = function()
    require("colorizer").setup({
      "*",               -- Habilita em todos os arquivos
      css = { css = true }, -- Suporte para CSS
      scss = { css = true },
      sass = { css = true },
      html = { mode = "foreground" }, -- Mostra a cor no próprio texto
      javascript = { names = true }, -- Habilita nomes de cores em JS
      typescript = { names = true },
      lua = { names = true },      -- Suporte para cores nomeadas em Lua
    }, { mode = "background" })    -- Exibe a cor como fundo (pode ser "foreground" também)
  end,
}
