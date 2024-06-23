local vim = vim


vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.netrw_winsize = 25

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.cursorline = true
vim.o.encoding = "utf-8"
vim.o.fillchars = "eob: "
vim.o.autoread = true
vim.g.coc_node_path = "/Users/bgmoura/.local/share/mise/installs/node/lts/bin/node"
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]


-- Add new line to the end of the file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup('UserOnSave', {}),
  pattern = '*',
  callback = function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank <= n_lines then
      vim.api.nvim_buf_set_lines(0,
        last_nonblank, n_lines, true, { '' })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = {
    spacing = 8,
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
  update_in_insert = false,
})


vim.api.nvim_create_autocmd({ "FocusGained" }, {
  pattern = "*",
  command = "hi! link Visual VisualActive",
})

vim.api.nvim_create_autocmd({ "FocusLost" }, {
  pattern = "*",
  command = "hi! link Visual VisualInactive",
})


-- Resizes
vim.api.nvim_create_user_command("Vr", function(opts)
  local usage = "Usage: [VirticalResize] :Vr {number (%)}"
  if not opts.args or not string.len(opts.args) == 2 then
    print(usage)
    return
  end
  vim.cmd(":vertical resize " .. vim.opt.columns:get() * (opts.args / 100.0))
end, { nargs = "*" })

vim.api.nvim_create_user_command("Hr", function(opts)
  local usage = "Usage: [HorizontalResize] :Hr {number (%)}"
  if not opts.args or not string.len(opts.args) == 2 then
    print(usage)
    return
  end
  vim.cmd(
    ":resize "
    .. (
      (vim.opt.lines:get() - vim.opt.cmdheight:get())
      * (opts.args / 100.0)
    )
  )
end, { nargs = "*" })
