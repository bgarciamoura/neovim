-- Python helpers shared by DAP, neotest, and the run/REPL keymaps.
--
-- Resolves the project interpreter (virtualenv-aware, Linux + Windows
-- layouts) and provides a toggleterm-backed REPL for sending code to.

local M = {}

-- Relative venv interpreter paths, in priority order.
local venv_candidates = {
  '/.venv/bin/python',
  '/venv/bin/python',
  '/.venv/Scripts/python.exe',
  '/venv/Scripts/python.exe',
}

--- Interpreter inside a virtualenv under `root` (default: cwd), or nil.
---@param root? string
---@return string|nil
function M.venv_python(root)
  root = root or vim.fn.getcwd()
  for _, rel in ipairs(venv_candidates) do
    local path = root .. rel
    if vim.fn.executable(path) == 1 then return path end
  end
  return nil
end

--- Best available interpreter: venv > python3 > python.
---@return string
function M.interpreter()
  local venv = M.venv_python()
  if venv then return venv end
  if vim.fn.executable('python3') == 1 then return 'python3' end
  return 'python'
end

--- Shell command to run `file` as a script.
--- Prefers the venv interpreter; falls back to `uv run` in uv projects.
---@param file string
---@return string
function M.run_command(file)
  local escaped = vim.fn.shellescape(file)
  local venv = M.venv_python()
  if venv then return venv .. ' ' .. escaped end

  local has_uv = vim.fn.executable('uv') == 1
  local has_pyproject = vim.uv.fs_stat(vim.fs.joinpath(vim.fn.getcwd(), 'pyproject.toml')) ~= nil
  if has_uv and has_pyproject then return 'uv run python ' .. escaped end

  return M.interpreter() .. ' ' .. escaped
end

-- ── REPL (toggleterm) ───────────────────────────────────────────────────────

local repl -- lazily created toggleterm Terminal

--- REPL command: ipython from the venv when available (handles pasted blocks
--- better than the plain REPL), otherwise the interpreter itself.
local function repl_command()
  local venv = M.venv_python()
  if venv then
    local ipython = vim.fs.dirname(venv) .. '/ipython'
    if vim.fn.executable(ipython) == 1 then return ipython .. ' --no-autoindent' end
    return venv
  end
  if vim.fn.executable('ipython') == 1 then return 'ipython --no-autoindent' end
  return M.interpreter()
end

local function get_repl()
  if repl then return repl end
  local ok, terminal = pcall(require, 'toggleterm.terminal')
  if not ok then
    vim.notify('toggleterm not available', vim.log.levels.WARN)
    return nil
  end
  repl = terminal.Terminal:new({
    cmd = repl_command(),
    hidden = true,
    direction = 'horizontal',
    close_on_exit = true,
    on_exit = function() repl = nil end,
  })
  return repl
end

--- Toggle the Python REPL terminal.
function M.repl_toggle()
  local term = get_repl()
  if term then term:toggle() end
end

--- Send the current line (normal) or visual selection to the REPL.
---@param mode 'line'|'visual'
function M.repl_send(mode)
  local term = get_repl()
  if not term then return end

  local lines
  if mode == 'visual' then
    local s = vim.fn.getpos("'<")[2]
    local e = vim.fn.getpos("'>")[2]
    lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
  else
    lines = { vim.api.nvim_get_current_line() }
  end

  if not term:is_open() then term:open() end
  -- Trailing blank line closes any open block in the REPL
  term:send(vim.list_extend(lines, { '' }), false)
end

--- Run the current file in a floating terminal.
function M.run_file()
  local file = vim.fn.expand('%:p')
  if file == '' then
    vim.notify('No file to run', vim.log.levels.WARN)
    return
  end
  vim.cmd('silent! write')
  vim.cmd(('TermExec cmd=%s direction=float'):format(vim.fn.shellescape(M.run_command(file))))
end

return M
