return {
  cmd = { 'typescript-language-server', '--stdio' },
  on_attach = function(client, _bufnr)
    -- Disable formatting (conform.nvim handles it via prettierd)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  -- Monorepo: anchors to nearest tsconfig.json (each package has its own)
  root_markers = {
    { 'tsconfig.json', 'jsconfig.json' },
    'package.json',
    '.git',
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
}
