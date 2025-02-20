local vim = vim

return {
  -- Plugin principal de autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Suporte ao LSP
      "hrsh7th/cmp-buffer",   -- Sugestões do buffer atual
      "hrsh7th/cmp-path",     -- Sugestões de arquivos
      "L3MON4D3/LuaSnip",     -- Suporte a snippets
      "saadparwaiz1/cmp_luasnip",
      "github/copilot.vim",   -- GitHub Copilot,
      "onsails/lspkind-nvim", -- Ícones no autocomplete
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',          -- show only symbol annotations
            maxwidth = {
              menu = 50,              -- leading text (labelDetails)
              abbr = 50,              -- actual suggestion item
            },
            ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            before = function(entry, vim_item)
              return vim_item
            end
          })
        },
        mapping    = {
          ["<C-n>"] = cmp.mapping.select_next_item(),        -- Próxima sugestão
          ["<C-p>"] = cmp.mapping.select_prev_item(),        -- Sugestão anterior
          ["<Down>"] = cmp.mapping.select_next_item(),       -- Próxima sugestão (seta para baixo)
          ["<Up>"] = cmp.mapping.select_prev_item(),         -- Sugestão anterior (seta para cima)
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirmação do autocomplete
          ["<ESC>"] = cmp.mapping.close(),                   -- Fecha o autocomplete
          ["<Tab>"] = cmp.mapping(function(fallback)
            local copilot_keys = vim.fn["copilot#Accept"]()
            if cmp.visible() then
              cmp.select_next_item()
            elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
              vim.api.nvim_feedkeys(copilot_keys, "i", true)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        },
        sources    = cmp.config.sources({
          { name = "nvim_lsp" }, -- Sugestões do LSP
          { name = "buffer" },   -- Sugestões do buffer
          { name = "path" },     -- Sugestões de arquivos
          { name = "luasnip" },  -- Snippets
          { name = "render-markdown" },
        }),
      })

      -- Fecha automaticamente o autocomplete após 3 segundos sem interação
      -- local close_autocomplete = function()
      --   if cmp.visible() then
      --     cmp.close()
      --   end
      -- end
      --
      -- -- Configura um evento para monitorar a inatividade
      -- cmp.event:on("menu_opened", function()
      --   vim.defer_fn(close_autocomplete, 10000) -- Fecha após 10000ms (10s)
      -- end)
    end,
  },

  -- Copilot
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
