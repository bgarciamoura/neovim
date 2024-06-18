local function map(mode, target_keys, command, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, target_keys, command, options)
end

-- map("n", "<leader>s", ":w<CR>")
-- map("n", "<leader>e", ":Explore<CR>")

map("n", "<C-a>", ":keepjumps normal! ggVG<CR>", { desc = "Select all text using control+a" })
map("n", "<A-up>", "<C-w>+", { desc = "Increase window size to up" })
map("n", "<A-down>", "<C-w>-", { desc = "Increase window size to down" })
map("n", "<A-left>", "<C-w><", { desc = "Increase window size to left" })
map("n", "<A-right>", "<C-w>>", { desc = "Increase window size to right" })
map("n", "<C-k>", "<C-W>j", { desc = "Move the cursor to the bottom window" })
map("n", "<C-h>", "<C-W>h", { desc = "Move the cursor to the left window" })
map("n", "<C-l>", "<C-W>l", { desc = "Move the cursor to the right window" })
map("n", "<C-j>", "<C-W>k", { desc = "Move the cursor to the top window" })
map("n", "<leader>cc", ':keepjumps normal! ggVG "*yG<CR>', { desc = "Copy the entire file to system clipboard" })
