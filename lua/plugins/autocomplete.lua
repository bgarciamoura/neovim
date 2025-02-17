local vim = vim

return {
  -- Plugin principal de autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Suporte ao LSP
      "hrsh7th/cmp-buffer", -- Sugestões do buffer atual
      "hrsh7th/cmp-path",  -- Sugestões de arquivos
      "L3MON4D3/LuaSnip",  -- Suporte a snippets
      "saadparwaiz1/cmp_luasnip",
      "github/copilot.vim", -- GitHub Copilot
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),   -- Próxima sugestão
          ["<C-p>"] = cmp.mapping.select_prev_item(),   -- Sugestão anterior
          ["<Down>"] = cmp.mapping.select_next_item(),  -- Próxima sugestão (seta para baixo)
          ["<Up>"] = cmp.mapping.select_prev_item(),    -- Sugestão anterior (seta para cima)
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirmação do autocomplete
          ["<ESC>"] = cmp.mapping.close(),              -- Fecha o autocomplete
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Sugestões do LSP
          { name = "buffer" }, -- Sugestões do buffer
          { name = "path" }, -- Sugestões de arquivos
          { name = "luasnip" }, -- Snippets
          { name = "render-markdown" },
        }),
      })

      -- Fecha automaticamente o autocomplete após 3 segundos sem interação
      local close_autocomplete = function()
        if cmp.visible() then
          cmp.close()
        end
      end

      -- Configura um evento para monitorar a inatividade
      cmp.event:on("menu_opened", function()
        vim.defer_fn(close_autocomplete, 3000) -- Fecha após 3000ms (3s)
      end)
    end,
  },

  -- Copilot
  {
    "github/copilot.vim",
    config = function()
      -- Atalhos para o Copilot
      vim.g.copilot_no_tab_map = true -- Não sobrescreve <Tab>
      vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },
}
