-- Highlight TODO/FIXME/HACK comments

require('todo-comments').setup({
  signs = true,
  keywords = {
    FIX  = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
    TODO = { icon = ' ', color = 'info' },
    HACK = { icon = ' ', color = 'warning' },
    WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
    PERF = { icon = ' ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
    NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
  },
})
