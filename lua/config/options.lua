-- Editor options

-- Leader key (must be set before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Tabs & indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- UI
vim.opt.fillchars = {
  eob = ' ',
  fold = ' ',
  foldopen = '▽',
  foldclose = '▷',
  foldsep = ' ',
}
vim.o.termguicolors = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.wrap = false
vim.o.showmode = false
vim.o.splitright = true
vim.o.splitbelow = true

-- Folding (treesitter-based, with LSP upgrade on attach)
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = ''
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 4
vim.o.foldcolumn = '1'

-- Completion (LSP native)
vim.o.autocomplete = true
vim.o.completeopt = 'menuone,noselect,popup,fuzzy'
vim.o.pumheight = 15

-- Performance
vim.o.updatetime = 300
vim.o.timeoutlen = 400

-- Persistence
vim.o.undofile = true
vim.o.swapfile = false
vim.o.backup = false

-- Clipboard
vim.o.clipboard = 'unnamedplus'

-- Mouse
vim.o.mouse = 'a'
