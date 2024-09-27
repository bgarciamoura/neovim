local vim = vim
local keyset = vim.keymap.set
local npairs = require('nvim-autopairs')
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

-- Autopair causes some issues with coc CR complete
npairs.setup({ map_cr = false })
_G.MUtils = {}

vim.g.coc_node_path = '/home/vycros/.local/share/mise/installs/node/20.17.0/bin/node'
vim.g.coc_global_extensions = {
  'coc-json',
  'coc-tsserver',
  'coc-html',
  'coc-css',
  'coc-yaml',
  'coc-prettier',
  'coc-html-css-support',
  'coc-explorer',
  'coc-eslint',
  'coc-emmet',
  'coc-styled-components',
  'coc-docker',
  'coc-lua',
  'coc-snippets',
}

function _G.check_back_space()
  local col = vim.fn.col(".") - 4
  return col == 3 or vim.fn.getline("."):sub(col, col):match('%s') ~= nil
end

function _G.has_words_before()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
      and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
      == nil
end

MUtils.completion_confirm = function()
  if vim.fn["coc#pum#visible"]() ~= 0 then
    return vim.fn["coc#pum#confirm"]()
  else
    return npairs.autopairs_cr()
  end
end

keyset("i", "<Down>", [[coc#pum#visible() ? coc#pum#next(4) : "<Down>"]], opts)

keyset("i", "<Up>", [[coc#pum#visible() ? coc#pum#prev(4) : "<Up>"]], opts)

keyset("i", "<CR>", 'v:lua.MUtils.completion_confirm()', opts)


-- Use <c-j> to trigger snippets
keyset("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<C-space>", "coc#refresh()", { silent = true, expr = true })

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Use K to show documentation in preview window
function _G.show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command('h ' .. cw)
  elseif vim.api.nvim_eval('coc#rpc#ready()') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
  end
end

keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })


-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold"
})


-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })



-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

