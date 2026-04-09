-- Keymaps
-- All keymaps use `desc` for mini.clue visibility

local map = vim.keymap.set

-- ── Core ────────────────────────────────────────────────────────────────────

-- Exit insert mode
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Clear search highlight
map('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Quit
map('n', '<C-q>', '<Cmd>qa<CR>', { desc = 'Quit Neovim' })

-- Save
map({ 'n', 'i', 'v' }, '<C-s>', '<Cmd>stopinsert | write<CR>', { desc = 'Save file' })

-- Select all
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })

-- Toggle comment (native gcc/gc in 0.12)
map('n', '<leader>;', 'gcc', { desc = "\u{f27a} Comment line", remap = true })
map('v', '<leader>;', 'gc', { desc = "\u{f27a} Comment selection", remap = true })

-- Undo / Redo
map({ 'n', 'i' }, '<C-z>', '<Cmd>undo<CR>', { desc = 'Undo' })
map('n', '<C-y>', '<C-r>', { desc = 'Redo' })
map('i', '<C-y>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  else
    return '<Cmd>redo<CR>'
  end
end, { expr = true, desc = 'Redo / Accept completion' })

-- ── Navigation ──────────────────────────────────────────────────────────────

-- Centered scrolling
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })
map('n', 'n', 'nzzzv', { desc = 'Next search (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search (centered)' })

-- Window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Resize splits
map('n', '<C-Up>', '<Cmd>resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<Cmd>resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<Cmd>vertical resize +2<CR>', { desc = 'Increase window width' })

-- Buffer navigation
map('n', '<S-h>', '<Cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<Cmd>bnext<CR>', { desc = 'Next buffer' })

-- ── Editing ─────────────────────────────────────────────────────────────────

-- Better indenting (stay in visual mode)
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Move lines
map('n', '<A-j>', '<Cmd>m .+1<CR>==', { desc = 'Move line down' })
map('n', '<A-k>', '<Cmd>m .-2<CR>==', { desc = 'Move line up' })
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- ── Terminal mode ───────────────────────────────────────────────────────────

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<Cmd>wincmd h<CR>', { desc = 'Move to left split' })
map('t', '<C-j>', '<Cmd>wincmd j<CR>', { desc = 'Move to lower split' })
map('t', '<C-k>', '<Cmd>wincmd k<CR>', { desc = 'Move to upper split' })
map('t', '<C-l>', '<Cmd>wincmd l<CR>', { desc = 'Move to right split' })

-- ── Completion (insert mode) ────────────────────────────────────────────────

map('i', '<C-Space>', function() vim.lsp.completion.get() end, { desc = 'Trigger completion' })

map('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  else
    return '<CR>'
  end
end, { expr = true, desc = 'Accept completion / Enter' })

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

-- ── Find (Telescope) <leader>f ──────────────────────────────────────────────

map('n', '<Space><Space>', '<Cmd>Telescope find_files<CR>', { desc = "\u{f002} Find files" })
map('n', '<leader>ff', '<Cmd>Telescope find_files<CR>', { desc = 'Find files' })
map('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', { desc = 'Live grep' })
map('n', '<leader>fb', '<Cmd>Telescope buffers<CR>', { desc = 'Buffers' })
map('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', { desc = 'Help tags' })
map('n', '<leader>ft', '<Cmd>TodoTelescope<CR>', { desc = 'Todo comments' })
map('n', '<leader>fd', '<Cmd>Telescope diagnostics<CR>', { desc = 'Diagnostics' })
map('n', '<leader>fr', '<Cmd>Telescope oldfiles<CR>', { desc = 'Recent files' })
map('n', '<leader>fs', '<Cmd>Telescope lsp_document_symbols<CR>', { desc = 'Document symbols' })
map('n', '<leader>fw', '<Cmd>Telescope grep_string<CR>', { desc = 'Grep word under cursor' })

-- ── Explorer (Neo-tree) <leader>e ───────────────────────────────────────────

map('n', '<leader>ee', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle explorer' })
map('n', '<leader>ef', '<Cmd>Neotree reveal<CR>', { desc = 'Reveal current file' })
map('n', '<leader>eg', '<Cmd>Neotree git_status<CR>', { desc = 'Git status' })
map('n', '<leader>eb', '<Cmd>Neotree buffers<CR>', { desc = 'Buffers' })

-- ── LSP <leader>l ───────────────────────────────────────────────────────────

map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
map('n', '<leader>ld', function() vim.lsp.buf.definition() end, { desc = 'Go to definition' })
map('n', '<leader>lr', '<Cmd>Telescope lsp_references<CR>', { desc = 'References' })
map('n', '<leader>ln', function() vim.lsp.buf.rename() end, { desc = 'Rename' })
map('n', '<leader>la', function() require('tiny-code-action').code_action() end, { desc = 'Code action' })
map('n', '<leader>lf', function() require('conform').format({ async = true, lsp_fallback = true }) end, { desc = 'Format' })
map('n', '<leader>li', '<Cmd>LspInfo<CR>', { desc = 'LSP info' })
map('n', '<leader>lh', function() vim.lsp.buf.hover() end, { desc = 'Hover' })
map('n', '<leader>ls', function() vim.lsp.buf.signature_help() end, { desc = 'Signature help' })
map('n', '<leader>lt', function() vim.lsp.buf.type_definition() end, { desc = 'Type definition' })
map('n', '<leader>ll', function() vim.diagnostic.open_float() end, { desc = 'Line diagnostics' })

-- Diagnostics navigation
map('n', ']d', function() vim.diagnostic.goto_next() end, { desc = 'Next diagnostic' })
map('n', '[d', function() vim.diagnostic.goto_prev() end, { desc = 'Previous diagnostic' })

-- ── Git <leader>g ───────────────────────────────────────────────────────────

map('n', '<leader>gg', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({
    cmd = 'lazygit',
    direction = 'float',
    float_opts = { border = 'rounded' },
    on_open = function(term)
      vim.cmd('startinsert!')
      vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<Cmd>close<CR>', { noremap = true, silent = true })
    end,
  })
  lazygit:toggle()
end, { desc = 'Lazygit' })

map('n', '<leader>gb', '<Cmd>Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle blame' })
map('n', '<leader>gp', '<Cmd>Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })
map('n', '<leader>gs', '<Cmd>Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
map('n', '<leader>gr', '<Cmd>Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
map('n', '<leader>gS', '<Cmd>Gitsigns stage_buffer<CR>', { desc = 'Stage buffer' })
map('n', '<leader>gR', '<Cmd>Gitsigns reset_buffer<CR>', { desc = 'Reset buffer' })
map('n', '<leader>gd', '<Cmd>Gitsigns diffthis<CR>', { desc = 'Diff this' })

-- Hunk navigation
map('n', ']h', '<Cmd>Gitsigns next_hunk<CR>', { desc = 'Next hunk' })
map('n', '[h', '<Cmd>Gitsigns prev_hunk<CR>', { desc = 'Previous hunk' })

-- ── Debug <leader>d ─────────────────────────────────────────────────────────

map('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle breakpoint' })
map('n', '<leader>dB', function()
  require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Conditional breakpoint' })
map('n', '<leader>dc', function() require('dap').continue() end, { desc = 'Continue' })
map('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Step into' })
map('n', '<leader>do', function() require('dap').step_over() end, { desc = 'Step over' })
map('n', '<leader>dO', function() require('dap').step_out() end, { desc = 'Step out' })
map('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'Toggle DAP UI' })
map('n', '<leader>dr', function() require('dap').repl.toggle() end, { desc = 'Toggle REPL' })
map('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'Run last' })
map('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Terminate' })

-- ── Terminal <leader>t ──────────────────────────────────────────────────────

map('n', '<leader>th', '<Cmd>ToggleTerm direction=horizontal<CR>', { desc = 'Horizontal terminal' })
map('n', '<leader>tv', '<Cmd>ToggleTerm direction=vertical<CR>', { desc = 'Vertical terminal' })
map('n', '<leader>tf', '<Cmd>ToggleTerm direction=float<CR>', { desc = 'Float terminal' })

-- ── Tests (neotest) <leader>n ───────────────────────────────────────────────

map('n', '<leader>nr', function() require('neotest').run.run() end, { desc = 'Run nearest test' })
map('n', '<leader>nf', function() require('neotest').run.run(vim.fn.expand('%')) end, { desc = 'Run file tests' })
map('n', '<leader>ns', function() require('neotest').run.run({ suite = true }) end, { desc = 'Run test suite' })
map('n', '<leader>no', function() require('neotest').output.open({ enter = true }) end, { desc = 'Open output' })
map('n', '<leader>nS', function() require('neotest').summary.toggle() end, { desc = 'Toggle summary' })
map('n', '<leader>nw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, { desc = 'Watch file' })

-- ── Buffers <leader>b ───────────────────────────────────────────────────────

map('n', '<leader>q', function()
  local listed = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
  if #listed <= 1 and #vim.api.nvim_list_wins() <= 1 then
    vim.cmd('quit')
  else
    vim.cmd('bdelete')
  end
end, { desc = "\u{f2d3} Close buffer / Quit" })
map('n', '<leader>bd', '<Cmd>bdelete<CR>', { desc = 'Delete buffer' })
map('n', '<leader>bn', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<leader>bp', '<Cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<leader>bD', '<Cmd>%bdelete<CR>', { desc = 'Delete all buffers' })

-- ── Notebook (Molten) <leader>j ─────────────────────────────────────────────

map('n', '<leader>ji', '<Cmd>MoltenInit<CR>', { desc = 'Initialize Molten' })
map('n', '<leader>jr', '<Cmd>MoltenEvaluateOperator<CR>', { desc = 'Evaluate operator' })
map('v', '<leader>jr', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'Evaluate visual' })
map('n', '<leader>jl', '<Cmd>MoltenEvaluateLine<CR>', { desc = 'Evaluate line' })
map('n', '<leader>ja', '<Cmd>MoltenReevaluateAll<CR>', { desc = 'Re-evaluate all' })
map('n', '<leader>jn', '<Cmd>MoltenNext<CR>', { desc = 'Next cell' })
map('n', '<leader>jp', '<Cmd>MoltenPrev<CR>', { desc = 'Previous cell' })
map('n', '<leader>jd', '<Cmd>MoltenDelete<CR>', { desc = 'Delete cell' })

-- ── Session (persistence) <leader>s ────────────────────────────────────────

map('n', '<leader>sr', function() require('persistence').load() end, { desc = 'Restore session (cwd)' })
map('n', '<leader>sl', function() require('persistence').load({ last = true }) end, { desc = 'Restore last session' })
map('n', '<leader>ss', function() require('persistence').select() end, { desc = 'Select session' })
map('n', '<leader>sd', function() require('persistence').stop() end, { desc = 'Stop auto-save' })

-- ── mini.clue setup ─────────────────────────────────────────────────────────

local ok_clue, miniclue = pcall(require, 'mini.clue')
if not ok_clue then return end
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
    -- Group labels with icons (Nerd Font codepoints)
    { mode = 'n', keys = '<Leader>b', desc = "\u{f0c5} Buffers" },
    { mode = 'n', keys = '<Leader>d', desc = "\u{f188} Debug" },
    { mode = 'n', keys = '<Leader>e', desc = "\u{f07b} Explorer" },
    { mode = 'n', keys = '<Leader>f', desc = "\u{f002} Find" },
    { mode = 'n', keys = '<Leader>g', desc = "\u{f126} Git" },
    { mode = 'n', keys = '<Leader>j', desc = "\u{f02d} Jupyter" },
    { mode = 'n', keys = '<Leader>l', desc = "\u{f085} LSP" },
    { mode = 'n', keys = '<Leader>n', desc = "\u{f0c3} Tests" },
    { mode = 'n', keys = '<Leader>s', desc = "\u{f0c7} Session" },
    { mode = 'n', keys = '<Leader>t', desc = "\u{f120} Terminal" },
  },
  window = {
    delay = 300,
    config = {
      width = 'auto',
    },
  },
})
