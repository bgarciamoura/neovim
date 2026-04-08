-- Molten.nvim configuration (Jupyter REPL)
-- Requires: pip install jupyter pynvim cairosvg

vim.g.molten_output_win_max_height = 20
vim.g.molten_auto_open_output = false
vim.g.molten_virt_text_output = true
vim.g.molten_wrap_output = true

local map = vim.keymap.set

map('n', '<leader>ji', '<Cmd>MoltenInit<CR>', { desc = 'Initialize kernel' })
map('n', '<leader>jr', '<Cmd>MoltenEvaluateLine<CR>', { desc = 'Run line' })
map('v', '<leader>jr', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'Run selection' })
map('n', '<leader>jR', '<Cmd>MoltenReevaluateAll<CR>', { desc = 'Re-run all cells' })
map('n', '<leader>jo', '<Cmd>MoltenShowOutput<CR>', { desc = 'Show output' })
map('n', '<leader>jh', '<Cmd>MoltenHideOutput<CR>', { desc = 'Hide output' })
map('n', '<leader>jd', '<Cmd>MoltenDelete<CR>', { desc = 'Delete cell' })
