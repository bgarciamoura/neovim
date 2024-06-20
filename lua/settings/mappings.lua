local function map(mode, target_keys, command, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, target_keys, command, options)
end

map("n", "<C-a>", ":keepjumps normal! ggVG<CR>", { desc = "Select all text using control+a" })
map("n", "<C-k>", "<CMD>resize +10<CR>", { desc = "Increase window size to up" })
map("n", "<C-j>", "<CMD>resize  -10<CR>", { desc = "Increase window size to down" })
map("n", "<C-h>", "<CMD>vertical resize +10<CR>", { desc = "Increase window size to left" })
map("n", "<C-l>", "<CMD>vertical resize -10<CR>", { desc = "Increase window size to right" })
map("n", "<A-down>", "<C-w>j", { desc = "Move the cursor to the bottom window" })
map("n", "<A-left>", "<C-w>h", { desc = "Move the cursor to the left window" })
map("n", "<A-right>", "<C-w>l", { desc = "Move the cursor to the right window" })
map("n", "<A-up>", "<C-w>k", { desc = "Move the cursor to the top window" })
map("n", "<leader>cc", ':keepjumps normal! ggVG "*yG<CR>', { desc = "Copy the entire file to system clipboard" })
map("n", "<leader>sv", ':vsplit<CR>', { desc = "Split the screen verticaly" })
map("n", "<leader>sh", ':split<CR>', { desc = "Split the screen horizontaly" })
map("n", "<leader>qo", '<C-w>o', { desc = "Close all splitted buffers but the active one" })
