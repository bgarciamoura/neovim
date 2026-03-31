local M = {}

-- Marker files mapped to project types
local MARKERS = {
  node = { "package.json" },
  python = { "pyproject.toml", "requirements.txt", "setup.py", "Pipfile" },
  flutter = { "pubspec.yaml" },
  docker = { "docker-compose.yml", "docker-compose.yaml", "Dockerfile" },
  bruno = { "collection.bru", "bruno.json" },
}

--- Detect project types by checking for marker files in cwd.
--- Returns a table like { node = true, python = true, ... }
function M.detect()
  local cwd = vim.fn.getcwd()
  local detected = {}

  for project_type, files in pairs(MARKERS) do
    for _, file in ipairs(files) do
      if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
        detected[project_type] = true
        break
      end
    end
  end

  -- Detect notebooks: any *.ipynb file in the root directory
  if vim.fn.glob(cwd .. "/*.ipynb") ~= "" then
    detected.notebook = true
  end

  return detected
end

--- Set vim.g flags based on detected project types.
--- Clears previous flags before re-detecting (important on DirChanged).
function M.setup()
  -- Clear all managed flags first so stale flags don't linger after a cd
  vim.g.project_has_node     = false
  vim.g.project_has_python   = false
  vim.g.project_has_flutter  = false
  vim.g.project_has_docker   = false
  vim.g.project_has_bruno    = false
  vim.g.project_has_notebook = false

  local detected = M.detect()

  if detected.node     then vim.g.project_has_node     = true end
  if detected.python   then vim.g.project_has_python   = true end
  if detected.flutter  then vim.g.project_has_flutter  = true end
  if detected.docker   then vim.g.project_has_docker   = true end
  if detected.bruno    then vim.g.project_has_bruno    = true end
  if detected.notebook then vim.g.project_has_notebook = true end
end

-- Run on startup and whenever the working directory changes
local group = vim.api.nvim_create_augroup("ProjectDetection", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = M.setup,
  desc = "Detect project type on startup",
})

vim.api.nvim_create_autocmd("DirChanged", {
  group = group,
  callback = M.setup,
  desc = "Re-detect project type after directory change",
})

return M
