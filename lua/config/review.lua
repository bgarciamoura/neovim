-- Helpers for reviewing changes and handing code context to a coding agent.

local M = {}

local fence_languages = {
  javascript = 'js',
  javascriptreact = 'jsx',
  typescript = 'ts',
  typescriptreact = 'tsx',
}

--- Current buffer's path, or nil (with a warning) for unnamed buffers.
---@param modifier string fnamemodify-style suffix for expand(), e.g. ':.'
---@return string|nil
local function buffer_path(modifier)
  if vim.api.nvim_buf_get_name(0) == '' then
    vim.notify('Buffer has no file name', vim.log.levels.WARN)
    return nil
  end
  return vim.fn.expand('%' .. modifier)
end

---@param text string
---@param message string
local function copy(text, message)
  vim.fn.setreg('+', text)
  vim.notify(message, vim.log.levels.INFO)
end

--- Yank `path#L<line>`, the format agents accept as a pointer to a line.
---@param modifier string ':.' for cwd-relative, ':p' for absolute
local function yank_path(modifier)
  local path = buffer_path(modifier)
  if not path then return end
  local reference = ('%s#L%d'):format(path, vim.fn.line('.'))
  copy(reference, 'Yanked: ' .. reference)
end

function M.yank_relative_path() yank_path(':.') end

function M.yank_absolute_path() yank_path(':p') end

--- Copy the last visual selection as a Markdown code block that names its
--- file and first line. Call after leaving visual mode, so '< and '> are set.
function M.yank_selection_as_codeblock()
  local path = buffer_path(':.')
  if not path then return end

  local first, last = vim.fn.line("'<"), vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)

  -- The fence must be longer than any backtick run in the code, or a selection
  -- containing Markdown would close the block early.
  local fence_length = 3
  for _, line in ipairs(lines) do
    for run in line:gmatch('`+') do
      fence_length = math.max(fence_length, #run + 1)
    end
  end
  local fence = ('`'):rep(fence_length)

  local language = fence_languages[vim.bo.filetype] or vim.bo.filetype
  local block = { ('%s%s filename="%s" line=%d'):format(fence, language, path, first) }
  vim.list_extend(block, lines)
  block[#block + 1] = fence

  copy(table.concat(block, '\n'), ('Copied %d lines as a code block'):format(#lines))
end

--- Parse the header of `git blame --porcelain` output for a single line.
---@param output string
---@return { sha: string, orig_line: integer, filename: string }|nil
local function parse_blame(output)
  local sha, orig_line = output:match('^(%x+) (%d+) ')
  local filename = output:match('\nfilename ([^\n]+)')
  if not (sha and filename) then return nil end
  return { sha = sha, orig_line = tonumber(orig_line), filename = filename }
end

--- Show a file as of a commit, read-only, in a new tab.
---@param root string repository root
---@param blame { sha: string, orig_line: integer, filename: string }
local function open_revision(root, blame)
  local spec = ('%s:%s'):format(blame.sha, blame.filename)
  local result = vim.system({ 'git', 'show', spec }, { cwd = root, text = true }):wait()
  if result.code ~= 0 then
    vim.notify('git show failed: ' .. (result.stderr or ''), vim.log.levels.ERROR)
    return
  end

  vim.cmd.tabnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false

  local lines = vim.split(result.stdout, '\n', { plain = true })
  if lines[#lines] == '' then table.remove(lines) end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = vim.filetype.match({ filename = blame.filename, buf = buf }) or ''
  -- pcall: the same revision may already be open, and buffer names are unique.
  pcall(vim.api.nvim_buf_set_name, buf, ('%s:%s'):format(blame.sha:sub(1, 8), blame.filename))
  -- Non-file buffers are skipped by the treesitter autocmd in autocmds.lua.
  pcall(vim.treesitter.start, buf)
  pcall(vim.api.nvim_win_set_cursor, 0, { blame.orig_line, 0 })
end

--- Open the current file as of the commit that last touched the cursor line,
--- to see the context of an old change without leaving the editor.
function M.open_line_commit()
  local path = buffer_path(':p')
  if not path then return end

  local root = vim.fs.root(0, '.git')
  if not root then
    vim.notify('Not inside a git repository', vim.log.levels.WARN)
    return
  end

  -- `--contents -` blames the buffer as it is now, so the cursor line still
  -- matches when there are unsaved edits above it.
  local buffer_text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n') .. '\n'
  local line = vim.fn.line('.')
  local result = vim.system(
    { 'git', 'blame', '--porcelain', '-L', ('%d,%d'):format(line, line), '--contents', '-', '--', path },
    { cwd = root, text = true, stdin = buffer_text }
  ):wait()
  if result.code ~= 0 then
    vim.notify('git blame failed: ' .. (result.stderr or ''), vim.log.levels.ERROR)
    return
  end

  local blame = parse_blame(result.stdout)
  if not blame then
    vim.notify('Could not parse git blame output', vim.log.levels.ERROR)
    return
  end
  if blame.sha:match('^0+$') then
    vim.notify('Line not committed yet', vim.log.levels.WARN)
    return
  end
  open_revision(root, blame)
end

-- Window lazygit was launched from; `e` inside lazygit opens files there.
local lazygit_origin_win = nil

--- Build the lazygit command, layering scripts/lazygit-nvim.yml over the
--- regular config. That override needs `sh`, so Windows runs plain lazygit.
---@return string
local function lazygit_command()
  if vim.fn.has('win32') == 1 then return 'lazygit' end

  local config_home = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(vim.env.HOME, '.config')
  local files = {
    vim.fs.joinpath(config_home, 'lazygit', 'config.yml'),
    vim.fs.joinpath(vim.fn.stdpath('config'), 'scripts', 'lazygit-nvim.yml'),
  }
  return ('lazygit --use-config-file "%s"'):format(table.concat(files, ','))
end

--- Open lazygit in a floating terminal, remembering the current window.
function M.open_lazygit()
  lazygit_origin_win = vim.api.nvim_get_current_win()

  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({
    cmd = lazygit_command(),
    direction = 'float',
    float_opts = { border = 'rounded' },
    on_open = function(term)
      vim.cmd('startinsert!')
      vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<Cmd>close<CR>', { noremap = true, silent = true })
    end,
  })
  lazygit:toggle()
end

--- Called by scripts/lazygit-nvim.yml. Does nothing if the origin window was
--- closed in the meantime.
function M.focus_lazygit_origin()
  if lazygit_origin_win and vim.api.nvim_win_is_valid(lazygit_origin_win) then
    vim.api.nvim_set_current_win(lazygit_origin_win)
  end
end

return M
