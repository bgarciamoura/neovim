-- Keymaps
-- All keymaps use `desc` for mini.clue visibility

local map = vim.keymap.set

-- Better navigation
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })
map('n', 'n', 'nzzzv', { desc = 'Next search (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search (centered)' })

-- Window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Buffer navigation
map('n', '<S-h>', '<Cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<Cmd>bnext<CR>', { desc = 'Next buffer' })

-- Better indenting (stay in visual mode)
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Move lines
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

-- Clear search highlight
map('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Save
map({ 'n', 'i', 'v' }, '<C-s>', '<Cmd>write<CR>', { desc = 'Save file' })

-- Close buffer
map('n', '<leader>q', function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
  if #bufs <= 1 then
    vim.cmd('quit')
  else
    vim.cmd('bdelete')
  end
end, { desc = 'Close buffer / Quit' })

-- Undo / Redo
map({ 'n', 'i' }, '<C-z>', '<Cmd>undo<CR>', { desc = 'Undo' })
map('n', '<C-y>', '<C-r>', { desc = 'Redo' })
map('i', '<C-y>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>' -- accept completion
  else
    return '<Cmd>redo<CR>'
  end
end, { expr = true, desc = 'Redo / Accept completion' })

-- Select all
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })

-- LSP keymaps (supplements Neovim 0.12 defaults: gra, grn, grr, gri, grt, grx, gO, K, C-S)
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Diagnostic float' })
map('n', '<leader>f', function() vim.lsp.buf.format({ timeout_ms = 1000 }) end, { desc = 'Format buffer' })

-- Completion keymaps (insert mode)
-- <C-Space> may not work on some terminals (especially Windows)
map('i', '<C-Space>', function() vim.lsp.completion.get() end, { desc = 'Trigger completion' })

-- Accept completion with Enter
map('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  else
    return '<CR>'
  end
end, { expr = true, desc = 'Accept completion / Enter' })

-- Tab/S-Tab: completion menu navigation OR snippet jump
map('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  elseif vim.snippet.active({ direction = 1 }) then
    return '<Cmd>lua vim.snippet.jump(1)<CR>'
  else
    return '<Tab>'
  end
end, { expr = true, desc = 'Next completion / snippet jump' })

map('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'
  elseif vim.snippet.active({ direction = -1 }) then
    return '<Cmd>lua vim.snippet.jump(-1)<CR>'
  else
    return '<S-Tab>'
  end
end, { expr = true, desc = 'Prev completion / snippet jump back' })

-- mini.clue setup
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'i', keys = '<C-x>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = 'z' },
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    -- Custom group labels
    { mode = 'n', keys = '<Leader>d', desc = '+Diagnostic' },
    { mode = 'n', keys = '<Leader>e', desc = '+Explorer' },
    { mode = 'n', keys = '<Leader>f', desc = '+Format' },
    { mode = 'n', keys = '<Leader>j', desc = '+Jupyter' },
  },
  window = {
    delay = 300,
    config = {
      width = 'auto',
    },
  },
})
