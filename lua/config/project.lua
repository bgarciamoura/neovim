-- Project type detection via marker files

local M = {}

local MARKERS = {
  node = { 'package.json' },
  python = { 'pyproject.toml', 'requirements.txt', 'setup.py', 'Pipfile' },
  flutter = { 'pubspec.yaml' },
  docker = { 'docker-compose.yml', 'docker-compose.yaml', 'Dockerfile' },
  notebook = {},
}

function M.detect()
  local cwd = vim.fn.getcwd()
  local detected = {}

  for project_type, files in pairs(MARKERS) do
    for _, file in ipairs(files) do
      if vim.fn.filereadable(cwd .. '/' .. file) == 1 then
        detected[project_type] = true
        break
      end
    end
  end

  if vim.fn.glob(cwd .. '/*.ipynb') ~= '' then
    detected.notebook = true
  end

  return detected
end

function M.setup()
  vim.g.project_has_node = false
  vim.g.project_has_python = false
  vim.g.project_has_flutter = false
  vim.g.project_has_docker = false
  vim.g.project_has_notebook = false

  local detected = M.detect()

  if detected.node then vim.g.project_has_node = true end
  if detected.python then vim.g.project_has_python = true end
  if detected.flutter then vim.g.project_has_flutter = true end
  if detected.docker then vim.g.project_has_docker = true end
  if detected.notebook then vim.g.project_has_notebook = true end
end

local group = vim.api.nvim_create_augroup('ProjectDetection', { clear = true })

vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  callback = M.setup,
  desc = 'Detect project type on startup',
})

vim.api.nvim_create_autocmd('DirChanged', {
  group = group,
  callback = M.setup,
  desc = 'Re-detect project type after directory change',
})

return M
