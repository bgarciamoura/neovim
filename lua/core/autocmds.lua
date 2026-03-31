local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank (Neovim 0.12 API)
local yank_group = augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = yank_group,
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
local trailing_ws_group = augroup("TrailingWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = trailing_ws_group,
  desc = "Remove trailing whitespace on save",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Restore cursor position on file reopen
local restore_cursor_group = augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = restore_cursor_group,
  desc = "Restore cursor position when reopening a file",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits on window resize
local resize_group = augroup("ResizeSplits", { clear = true })
autocmd("VimResized", {
  group = resize_group,
  desc = "Auto-resize splits when terminal window is resized",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Close certain filetypes with q
local close_with_q_group = augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = close_with_q_group,
  pattern = { "help", "qf", "notify", "checkhealth", "man", "lspinfo" },
  desc = "Close certain filetypes with q",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})
