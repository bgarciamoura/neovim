local vim = vim
local keyset = vim.keymap.set

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

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }



-- keyset("i", "<Down>",
-- 'coc#pum#visible() ? coc#pum#next(4) : v:lua.check_back_space() ? "<Down>" :  v:lua.has_words_before() ? coc#refresh() : "<Down>"',
-- opts)

-- Close the completion menu if it's opened, or just move the cursor down


keyset("i", "<Down>", [[coc#pum#visible() ? coc#pum#next(4) : "<Down>"]], opts)

keyset("i", "<Up>", [[coc#pum#visible() ? coc#pum#prev(4) : "<Up>"]], opts)

keyset("i", "<cr>", [[coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm() : "<CR>"]], opts)
-- Use <c-space> to trigger completion
keyset("i", "<C-space>", "coc#refresh()", { silent = true, expr = true })

-- Use <c-j> to trigger snippets
keyset("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)")

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

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

