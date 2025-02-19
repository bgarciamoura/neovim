return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Atualiza os parsers automaticamente
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "typescript",
          "javascript",
          "tsx",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "bash",
          "markdown",
        },                             -- Instala os parsers automaticamente:w

        highlight = { enable = true }, -- Ativa o realce de sintaxe
        indent = { enable = true },    -- Melhor indentação automática
        -- autotag = { enable = true }, -- Fecha automaticamente tags HTML/JSX
      })
    end,
  },
}
