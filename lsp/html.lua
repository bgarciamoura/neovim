return {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ' },
  root_markers = { '.git' },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
