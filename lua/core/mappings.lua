local function map(mode, target_keys, command, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, target_keys, command, options)
end

map("n", "<C-a>", ":keepjumps normal! ggVG<CR>", { desc = "Select all text using control+a" })
map("n", "<A-k>", "<CMD>resize +10<CR>", { desc = "Increase window size to up" })
map("n", "<A-j>", "<CMD>resize  -10<CR>", { desc = "Increase window size to down" })
map("n", "<A-h>", "<CMD>vertical resize +10<CR>", { desc = "Increase window size to left" })
map("n", "<A-l>", "<CMD>vertical resize -10<CR>", { desc = "Increase window size to right" })
map("n", "<A-down>", "<C-w>j", { desc = "Move the cursor to the bottom window" })
map("n", "<A-left>", "<C-w>h", { desc = "Move the cursor to the left window" })
map("n", "<A-right>", "<C-w>l", { desc = "Move the cursor to the right window" })
map("n", "<A-up>", "<C-w>k", { desc = "Move the cursor to the top window" })
map("n", "<leader>cc", ':keepjumps normal! ggVG "*yG<CR>', { desc = "Copy the entire file to system clipboard" })
map("n", "<leader>sv", ':vsplit<CR>', { desc = "Split the screen verticaly" })
map("n", "<leader>sh", ':split<CR>', { desc = "Split the screen horizontaly" })
map("n", "<leader>qo", '<C-w>o', { desc = "Close all splitted buffers but the active one" })
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Open or close Neotree" })
map("n", "<leader>jj", ":Neotree focus<CR>", { desc = "Focus on Neotree buffer" })

map('n', '<leader>r', ':so %<CR>', { desc = "Reload configuration without restart nvim" })
map('n', '<leader>q', ':qa!<CR>', { desc = "Close all windows and exit from Neovim with <leader> and q" })


-- Codeium
map('i', '<C-g>', "<cmd>call codeium#Accept()<CR>", { desc = "Accept codeium suggestion" })
map('i', '<C-;>', "<cmd>call codeium#CycleCompletions(1)<CR>", { desc = "Cycle codeium suggestion" })
map('i', '<C-,>', "<cmd>call codeium#CycleCompletions(-1)<CR>", { desc = "Cycle codeium suggestion" })
map('i', '<C-x>', "<cmd>call codeium#Clear()<CR>", { desc = "Clear codeium suggestion" })

