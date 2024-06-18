vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.cursorline = true
vim.o.encoding = "utf-8"
vim.o.fillchars = "eob: "

vim.g.netrw_winsize = 25

-- vim.lsp.inlay_hint.enable()
-- Add new line to the end of the file
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  group = vim.api.nvim_create_augroup('UserOnSave', {}),
  pattern = '*',
  callback = function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank <= n_lines then vim.api.nvim_buf_set_lines(0,
      last_nonblank, n_lines, true, { '' })
    end
  end,
})

