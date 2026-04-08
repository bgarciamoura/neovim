-- Formatting via external tools

require('conform').setup({
  formatters_by_ft = {
    javascript      = { 'prettierd', stop_after_first = true },
    javascriptreact = { 'prettierd', stop_after_first = true },
    typescript      = { 'prettierd', stop_after_first = true },
    typescriptreact = { 'prettierd', stop_after_first = true },
    json            = { 'prettierd', stop_after_first = true },
    jsonc           = { 'prettierd', stop_after_first = true },
    yaml            = { 'prettierd', stop_after_first = true },
    html            = { 'prettierd', stop_after_first = true },
    css             = { 'prettierd', stop_after_first = true },
    scss            = { 'prettierd', stop_after_first = true },
    markdown        = { 'prettierd', stop_after_first = true },
    python          = { 'black' },
    lua             = { 'stylua' },
    dart            = { 'dart_format' },
  },
  format_on_save = {
    timeout_ms = 3000,
    lsp_format = 'fallback',
  },
  notify_on_error = true,
})
