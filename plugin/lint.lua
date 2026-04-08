-- Linting via external tools

local lint = require('lint')

lint.linters_by_ft = {
  javascript      = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescript      = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  python          = { 'ruff' },
  lua             = { 'luacheck' },
  markdown        = { 'markdownlint' },
  dockerfile      = { 'hadolint' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
  callback = function()
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})
