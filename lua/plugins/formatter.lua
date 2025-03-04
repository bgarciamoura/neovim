local vim = vim

return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Dependência necessária
    config = function()
      local null_ls = require("null-ls")
      local biome = null_ls.builtins.formatting.rome.with({
        command = "biome",
        args = { "format", "--stdin" },
        to_stdin = true,
      }),
      null_ls.setup({
        sources = {
          -- Formatadores
          --null_ls.builtins.formatting.prettier, -- Para JS, TS, JSON, HTML, CSS
          biome,
          null_ls.builtins.formatting.stylua, -- Para Lua
          -- Linters
          null_ls.builtins.diagnostics.eslint_d.with({
            diagnostics_format = "[eslint] #{m} (#{c})", -- Formato de erro melhorado
            condition = function(utils)
              return utils.root_has_file(".eslintrc.js") or utils.root_has_file(".eslintrc.json")
            end,
          }),
        },
      })

      -- Ativar formatação automática ao salvar
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.html", "*.css", "*.lua" },
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
  },
}
