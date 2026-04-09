-- Flutter development tools (replaces raw dartls)

local ok, flutter = pcall(require, 'flutter-tools')
if not ok then return end

flutter.setup({
  debugger = {
    enabled = true,
    run_via_dap = true,
  },
  lsp = {
    on_attach = function(client, _bufnr)
      -- Disable formatting from LSP (conform.nvim handles it)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
})
