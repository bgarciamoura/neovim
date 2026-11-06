-- Interface options that apply across plugins

-- Rounded borders on every floating window that doesn't set its own
vim.o.winborder = 'rounded'

-- Fill the empty side of diffs, so deleted and added regions read as gaps
vim.opt.fillchars:append({ diff = '╱' })
