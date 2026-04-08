-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- LSP attach: completion, folding, server-specific tweaks
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
  end,
})

-- Native treesitter highlight (Neovim 0.12)
local ignored_fts = {
  [''] = true, alpha = true, ['neo-tree'] = true, notify = true,
  TelescopePrompt = true, TelescopeResults = true, toggleterm = true,
}

autocmd({ 'FileType', 'BufReadPost', 'BufWinEnter' }, {
  group = augroup('treesitter-highlight', { clear = true }),
  desc = 'Enable native treesitter highlight',
  callback = function(event)
    local buf = event.buf
    if vim.bo[buf].buftype ~= '' then return end

    local ft = vim.bo[buf].filetype
    if ft == '' then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= '' then
        local detected = vim.filetype.match({ buf = buf, filename = name })
        if detected then
          vim.bo[buf].filetype = detected
        end
      end
      return
    end

    if ignored_fts[ft] then return end
    pcall(vim.treesitter.start, buf)
  end,
})

-- Highlight yanked text
autocmd('TextYankPost', {
  group = augroup('highlight-yank', {}),
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
autocmd('BufWritePre', {
  group = augroup('trailing-whitespace', { clear = true }),
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Resize splits on window resize
autocmd('VimResized', {
  group = augroup('resize-splits', {}),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
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

-- Close certain filetypes with q
autocmd('FileType', {
  group = augroup('close-with-q', { clear = true }),
  pattern = { 'help', 'qf', 'notify', 'checkhealth', 'man', 'lspinfo' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<Cmd>close<CR>', {
      buffer = event.buf,
      silent = true,
      desc = 'Close window',
    })
  end,
})
