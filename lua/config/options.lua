-- Editor options

-- Disable netrw (replaced by neo-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key (must be set before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Tabs & indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
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
vim.o.statuscolumn = '%s%C %l  '
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
pcall(function() vim.o.autocomplete = true end)
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

-- Behaviour
vim.o.confirm = true
vim.o.mouse = 'a'

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    prefix = '',
    spacing = 2,
    source = 'if_many',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN]  = ' ',
      [vim.diagnostic.severity.HINT]  = ' ',
      [vim.diagnostic.severity.INFO]  = ' ',
    },
  },
  float = {
    border = 'rounded',
    source = 'always',
  },
})

-- LSP UI (rounded borders)
vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
  config = config or {}
  config.border = 'rounded'
  return vim.lsp.handlers.hover(err, result, ctx, config)
end
vim.lsp.handlers['textDocument/signatureHelp'] = function(err, result, ctx, config)
  config = config or {}
  config.border = 'rounded'
  return vim.lsp.handlers.signature_help(err, result, ctx, config)
end
