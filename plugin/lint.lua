-- Linting via external tools

local ok, lint = pcall(require, 'lint')
if not ok then return end

-- Only register linters whose binary is available
local all_linters = {
  lua             = { 'luacheck' },
  markdown        = { 'markdownlint' },
  dockerfile      = { 'hadolint' },
}

for ft, linters in pairs(all_linters) do
  local available = {}
  for _, name in ipairs(linters) do
    if vim.fn.executable(name) == 1 then
      table.insert(available, name)
    end
  end
  if #available > 0 then
    lint.linters_by_ft[ft] = available
  end
end

vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
  callback = function()
    if vim.bo.buftype ~= '' then return end
    if not vim.bo.modifiable then return end
    pcall(lint.try_lint)
  end,
})
