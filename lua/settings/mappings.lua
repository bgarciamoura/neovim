local function map(mode, target_keys, command, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, target_keys, command, options)
end

-- map("n", "<leader>s", ":w<CR>")
-- map("n", "<leader>e", ":Explore<CR>")
