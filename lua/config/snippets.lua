-- Custom snippets are defined in snippets/*.json (VSCode format)
-- blink.cmp reads them automatically via search_paths config
--
-- Manual expand: type prefix + <C-l> as a fallback when completion menu is closed

local function get_word_before_cursor()
  local col = vim.fn.col('.') - 1
  if col == 0 then return '' end
  local line = vim.api.nvim_get_current_line()
  local word_start = col
  while word_start > 0 and line:sub(word_start, word_start):match('[%w_]') do
    word_start = word_start - 1
  end
  return line:sub(word_start + 1, col)
end

-- Load VSCode JSON snippets for current filetype
local snippet_cache = {}
local function get_snippets(ft)
  if snippet_cache[ft] then return snippet_cache[ft] end

  local result = {}
  local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'snippets')
  local pkg_path = vim.fs.joinpath(dir, 'package.json')
  local pkg_ok, pkg_raw = pcall(vim.fn.readfile, pkg_path)
  if not pkg_ok then return result end

  local pkg = vim.json.decode(table.concat(pkg_raw, '\n'))
  for _, entry in ipairs(pkg.contributes.snippets) do
    local langs = entry.language
    if vim.list_contains(langs, ft) or vim.list_contains(langs, 'all') then
      local file_path = vim.fs.joinpath(dir, entry.path:gsub('^%./', ''))
      local ok, raw = pcall(vim.fn.readfile, file_path)
      if ok then
        local data = vim.json.decode(table.concat(raw, '\n'))
        for _, snip in pairs(data) do
          local body = type(snip.body) == 'table' and table.concat(snip.body, '\n') or snip.body
          result[snip.prefix] = body
        end
      end
    end
  end

  snippet_cache[ft] = result
  return result
end

vim.keymap.set('i', '<C-l>', function()
  local word = get_word_before_cursor()
  local ft_snippets = get_snippets(vim.bo.filetype)

  if ft_snippets[word] then
    local col = vim.fn.col('.')
    local row = vim.fn.line('.') - 1
    vim.api.nvim_buf_set_text(0, row, col - #word - 1, row, col - 1, {})
    vim.snippet.expand(ft_snippets[word])
  end
end, { desc = 'Expand snippet' })
