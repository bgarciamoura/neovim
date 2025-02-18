local function map(mode, target_keys, command, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, target_keys, command, options)
end

return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    -- Adicionar/remover cursores
    map(
      "n",
      "<S-Up>",
      "<cmd>lua require('multicursor-nvim').lineAddCursor(-1)<CR>",
      { desc = "Adicionar cursor acima" }
    )
    map(
      "n",
      "<S-Down>",
      "<cmd>lua require('multicursor-nvim').lineAddCursor(1)<CR>",
      { desc = "Adicionar cursor abaixo" }
    )
    map(
      "n",
      "<leader><Up>",
      "<cmd>lua require('multicursor-nvim').lineSkipCursor(-1)<CR>",
      { desc = "Pular cursor acima" }
    )
    map(
      "n",
      "<leader><Down>",
      "<cmd>lua require('multicursor-nvim').lineSkipCursor(1)<CR>",
      { desc = "Pular cursor abaixo" }
    )

    -- Adicionar/remover cursores por correspondência
    map(
      "n",
      "<leader>n",
      "<cmd>lua require('multicursor-nvim').matchAddCursor(1)<CR>",
      { desc = "Adicionar cursor na próxima correspondência" }
    )
    map(
      "n",
      "<leader>s",
      "<cmd>lua require('multicursor-nvim').matchSkipCursor(1)<CR>",
      { desc = "Pular cursor na próxima correspondência" }
    )
    map(
      "n",
      "<leader>N",
      "<cmd>lua require('multicursor-nvim').matchAddCursor(-1)<CR>",
      { desc = "Adicionar cursor na correspondência anterior" }
    )
    map(
      "n",
      "<leader>S",
      "<cmd>lua require('multicursor-nvim').matchSkipCursor(-1)<CR>",
      { desc = "Pular cursor na correspondência anterior" }
    )

    -- Adicionar todos os cursores correspondentes
    map(
      "n",
      "<leader>A",
      "<cmd>lua require('multicursor-nvim').matchAllAddCursors()<CR>",
      { desc = "Adicionar cursores em todas as correspondências" }
    )

    -- Alternar entre cursores
    map(
      "n",
      "<S-Left>",
      "<cmd>lua require('multicursor-nvim').nextCursor()<CR>",
      { desc = "Mover para o próximo cursor" }
    )
    map(
      "n",
      "<S-Right>",
      "<cmd>lua require('multicursor-nvim').prevCursor()<CR>",
      { desc = "Mover para o cursor anterior" }
    )

    -- Deletar cursores
    map(
      "n",
      "<leader>x",
      "<cmd>lua require('multicursor-nvim').deleteCursor()<CR>",
      { desc = "Deletar o cursor atual" }
    )

    -- Manuseio do mouse
    map(
      "n",
      "<C-LeftMouse>",
      "<cmd>lua require('multicursor-nvim').handleMouse()<CR>",
      { desc = "Adicionar/remover cursor com o mouse" }
    )
    map(
      "n",
      "<C-LeftDrag>",
      "<cmd>lua require('multicursor-nvim').handleMouseDrag()<CR>",
      { desc = "Arrastar para criar cursores" }
    )

    -- Restaurar cursores
    map(
      "n",
      "<leader>gv",
      "<cmd>lua require('multicursor-nvim').restoreCursors()<CR>",
      { desc = "Restaurar cursores apagados" }
    )

    -- Estilização dos cursores múltiplos
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
  end,
}
