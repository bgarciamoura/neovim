-- Session management (deferred to avoid slowing startup)

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    local ok, persistence = pcall(require, 'persistence')
    if not ok then return end

    persistence.setup({
      need = 1,
      branch = true,
    })
  end,
})

-- Close Neo-tree and wipe its buffers before saving
vim.api.nvim_create_autocmd('User', {
  pattern = 'PersistenceSavePre',
  callback = function()
    pcall(vim.cmd, 'Neotree close')
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].filetype == 'neo-tree' then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end,
})

-- Re-attach treesitter/LSP after restoring
vim.api.nvim_create_autocmd('User', {
  pattern = 'PersistenceLoadPost',
  callback = function()
    vim.defer_fn(function()
      -- Kill any neo-tree buffers that leaked into the session
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == 'neo-tree'
          or (vim.api.nvim_buf_get_name(buf)):match('neo%-tree') then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
      end
      -- Re-attach treesitter/LSP on real file buffers
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
