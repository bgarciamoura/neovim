return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  -- Monorepo: anchors to nearest pyproject.toml
  root_markers = {
    'pyproject.toml',
    'pyrightconfig.json',
    'setup.py',
    'setup.cfg',
    '.git',
  },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}
