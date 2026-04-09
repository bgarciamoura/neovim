-- Linting via external tools

local ok, lint = pcall(require, 'lint')
if not ok then return end

lint.linters_by_ft = {
  -- JS/TS: eslint is now an LSP server (provides code actions)
  -- Python: ruff is now an LSP server (provides code actions)
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
