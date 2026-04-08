return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose' },
  root_markers = { '.git' },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
      validate = true,
      completion = true,
      hover = true,
    },
  },
}
