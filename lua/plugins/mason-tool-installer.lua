return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "eslint_d",        -- Ferramenta para linting rápido
        "prettierd",       -- Formatação com Prettier mais rápida
        "stylua",          -- Formatação para Lua
        "shfmt",           -- Formatação para Shell Scripts
      },
      auto_update = true,  -- Atualiza automaticamente as ferramentas instaladas
      run_on_start = true, -- Instala automaticamente ao iniciar o Neovim
      integrations = {
        ['mason-lspconfig'] = true,
        ['mason-null-ls'] = true,
        ['mason-nvim-dap'] = false,
      },
    })
  end,
}
