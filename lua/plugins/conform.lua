local conform = require("conform")


conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
    css = { "stylelint" }
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}
