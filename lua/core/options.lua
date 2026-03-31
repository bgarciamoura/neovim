-- Disable netrw (replaced by neo-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader keys (must be set before lazy.nvim loads)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs / indentation (default 2 spaces)
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Scroll offset
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Undo
opt.undofile = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmode = false
opt.cursorline = true
opt.wrap = false
opt.fillchars = { eob = " " }

-- Mouse
opt.mouse = "a"

-- Timing
opt.timeoutlen = 300
opt.updatetime = 250

-- Behaviour
opt.confirm = true

