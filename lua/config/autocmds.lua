-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- LSP attach: completion, formatting, server-specific tweaks
autocmd('LspAttach', {
  group = augroup('lsp-attach', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    -- Enable LSP completion with autotrigger
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    -- Upgrade to LSP folding when supported (more accurate than treesitter)
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    -- Disable ruff hover (let pyright handle it)
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end

    -- Format on save (once per buffer, not per client)
    if client:supports_method('textDocument/formatting') then
      if not vim.b[ev.buf].lsp_format_attached then
        vim.b[ev.buf].lsp_format_attached = true
        autocmd('BufWritePre', {
          group = augroup('lsp-format', { clear = false }),
          buffer = ev.buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = ev.buf, timeout_ms = 1000 })
          end,
        })
      end
    end
  end,
})

-- Highlight yanked text
autocmd('TextYankPost', {
  group = augroup('highlight-yank', {}),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Resize splits on window resize
autocmd('VimResized', {
  group = augroup('resize-splits', {}),
  command = 'tabdo wincmd =',
})

-- Return to last edit position when opening files
autocmd('BufReadPost', {
  group = augroup('last-position', {}),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
