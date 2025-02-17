local vim = vim

return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        signs = {
          error = "🔥", -- Ícone personalizado para erros
          warning = "⚠️",
          hint = "💡",
          information = "ℹ️",
        },
      })

      -- Mapeamento para abrir o Trouble
      vim.api.nvim_set_keymap(
        "n",
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        { noremap = true, silent = true }
      )
    end,
  },
}
