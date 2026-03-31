return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        -- JS / TS ecosystem
        javascript      = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript      = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        -- Python
        python          = { "ruff" },
        -- Lua
        lua             = { "luacheck" },
        -- Markdown
        markdown        = { "markdownlint" },
        -- Docker
        dockerfile      = { "hadolint" },
      }

      -- Trigger linting on save, leaving insert mode, and entering a buffer
      vim.api.nvim_create_autocmd(
        { "BufWritePost", "InsertLeave", "BufEnter" },
        {
          group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
          callback = function()
            -- Only lint modifiable buffers to avoid noise in read-only windows
            if vim.bo.modifiable then
              lint.try_lint()
            end
          end,
        }
      )
    end,
  },
}
