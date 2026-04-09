-- Session management

local ok, persistence = pcall(require, 'persistence')
if not ok then return end

persistence.setup({
  need = 1,
  branch = true,
})

-- Re-attach treesitter/LSP after restoring a session
vim.api.nvim_create_autocmd('User', {
  pattern = 'PersistenceLoadPost',
  callback = function()
    vim.defer_fn(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
          local name = vim.api.nvim_buf_get_name(buf)
          if name ~= '' and vim.fn.filereadable(name) == 1 then
            vim.api.nvim_buf_call(buf, function()
              vim.cmd('silent! edit')
            end)
          end
        end
      end
    end, 100)
  end,
})
