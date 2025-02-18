vim.api.nvim_set_hl(0, "IndentBlankline", { fg = "#313131", nocombine = true })

return {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require("ibl").setup({
      indent = {
        char = "▏", -- Pode ser alterado para "⦙", "┆", "┊"
        highlight = "IndentBlankline", -- Nome do destaque que vamos personalizar
      },
    })
  end,
}
