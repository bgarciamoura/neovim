local vim = vim 

return {
  -- Plugin principal de autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- Suporte ao LSP
      "hrsh7th/cmp-buffer",    -- Sugestões do buffer atual
      "hrsh7th/cmp-path",      -- Sugestões de arquivos
      "L3MON4D3/LuaSnip",      -- Suporte a snippets
      "saadparwaiz1/cmp_luasnip",
      "github/copilot.vim",    -- GitHub Copilot
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),   -- Navega para baixo nas sugestões
          ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Navega para cima
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirmação do autocomplete
          ["<ESC>"] = cmp.mapping.close(), -- Fecha o autocomplete
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },  -- Sugestões do LSP
          { name = "buffer" },    -- Sugestões do buffer
          { name = "path" },      -- Sugestões de arquivos
          { name = "luasnip" },   -- Snippets
        })
      })
    end
  },

  -- Copilot
  {
    "github/copilot.vim",
    config = function()
      -- Atalhos para o Copilot
      vim.g.copilot_no_tab_map = true -- Não sobrescreve <Tab>
      vim.api.nvim_set_keymap("i", "<C-Space>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end
  }
}
