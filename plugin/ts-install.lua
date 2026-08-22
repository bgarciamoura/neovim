-- Treesitter parser management via nvim-treesitter (main branch for 0.12)
-- Highlight, folding, and commenting are handled natively by Neovim 0.12
-- nvim-treesitter is used ONLY for parser installation and query files
--
-- On the main branch `setup()` no longer accepts `ensure_installed`; parsers
-- are installed explicitly with `install()` (async, requires the
-- `tree-sitter` CLI and a C compiler — see :checkhealth nvim-treesitter).

local ok, ts = pcall(require, 'nvim-treesitter')
if not ok then return end

ts.setup({})

local ensure_installed = {
  'typescript',
  'tsx',
  'javascript',
  'python',
  'lua',
  'dart',
  'json',
  'yaml',
  'toml',
  'html',
  'css',
  'markdown',
  'markdown_inline',
  'bash',
  'regex',
  'vim',
  'vimdoc',
  'dockerfile',
  'gitignore',
  'http', -- .http files (kulala)
}

--- Install any parsers from `langs` that are not yet on disk (async).
---@param langs string[]
local function install_missing(langs)
  local installed = {}
  for _, lang in ipairs(ts.get_installed('parsers')) do
    installed[lang] = true
  end

  local missing = vim.tbl_filter(function(lang) return not installed[lang] end, langs)
  if #missing == 0 then return end

  if vim.fn.executable('tree-sitter') ~= 1 then
    vim.notify(
      'nvim-treesitter: `tree-sitter` CLI not found — parsers cannot be installed (npm i -g tree-sitter-cli)',
      vim.log.levels.WARN
    )
    return
  end

  ts.install(missing)
end

install_missing(ensure_installed)

-- auto_install: when opening a filetype with an available-but-missing parser
local available -- lazily computed set of installable parsers
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config_ts_auto_install', { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then return end

    if not available then
      available = {}
      for _, l in ipairs(ts.get_available()) do
        available[l] = true
      end
    end

    if available[lang] and not vim.list_contains(ts.get_installed('parsers'), lang) then
      install_missing({ lang })
    end
  end,
})
