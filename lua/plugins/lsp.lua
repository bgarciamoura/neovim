return {
  -- Plugin principal do LSP
  { "neovim/nvim-lspconfig" },

  -- Mason: Gerenciador de LSPs
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  -- Mason-LSPConfig: Integra Mason com o LSP
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "eslint", "html", "cssls", "jsonls", "lua_ls" },
      })
      require("mason-tool-installer").setup({
        ensure_installed = { "eslint_d", "prettier", "stylelint", "jsonlint", "stylua" },
      })
    end
  }
}
