local which_key = require("which-key")
local default_opts = { noremap = true, silent = true }

local which_key_opts = {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    }
  },
  key_labels = { ["<space>"] = "SPC", ["<CR>"] = "ENTER" },
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "center",
  },
  ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<cr>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true,
  triggers_nowait = {
  },
}

local files_shortcuts = {
  name = "File",
  s = { ":w<CR>", "Save File", unpack(default_opts) },
  q = { ":q<CR>", "Close File", unpack(default_opts) },
}

local explorer_shortcuts = {
  name = "Explore",
  e = { ":Neotree toggle<CR>", "Open a Side File Explorer using NEOTREE", unpack(default_opts) },
  -- e = { ":Lexplore<CR>", "Open a Side File Explorer On Current Path", unpack(default_opts) },
  f = { ":Explore<CR>", "Open File Explorer On Current Path", unpack(default_opts) },
}

local which_key_shortcuts = {
  name = "Suggestions",
  z = "Show Which Keys Suggestions"
}

local lazygit_shortcuts = {
  name = "LazyGit",
  g = { ":LazyGit<CR>", "Open the lazygit window to perform git actions", unpack(default_opts) },
}

local telescope_shortcuts = {
  name = "Telescope",
  f = { "<cmd>lua require('telescope.builtin').find_files()<CR>", "Find current folder files using Telescope", unpack(default_opts) },
  g = { "<cmd>lua require('telescope.builtin').live_grep()<CR>", "Grepping using Telescope", unpack(default_opts) },
  b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Find in opened buffers using Telescope", unpack(default_opts) },
  h = { "<cmd>lua require('telescope.builtin').help_tags()<CR>", "Find help in plugins/neovim docs using Telescope", unpack(default_opts) },
  i = { "<cmd>lua require('telescope.builtin').git_files()<CR>", "Find just git files on current dir using Telescope", unpack(default_opts) },
  x = { "<cmd>lua require('telescope.builtin').colorscheme()<CR>", "Find and change the theme using Telescope", unpack(default_opts) },
  c = { ":Telescope themes<CR>", "Find and change the theme using Telescope", unpack(default_opts) },
  q = { "<cmd>lua require('telescope.builtin').quickfix()<CR>", "Find items in quickfix list using Telescope", unpack(default_opts) },
  u = { "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", "Live fuzzy search inside of the currently open buffer", unpack(default_opts) },
  r = { "<cmd>lua require('telescope.builtin').lsp_references()<CR>", "Lists LSP references for word under the cursor", unpack(default_opts) },
  d = { "<cmd>lua require('telescope.builtin').diagnostics(0)<CR>", "Lists Diagnostics open buffer", unpack(default_opts) },
  m = { "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", "Goto the implementation of the word under the cursor", unpack(default_opts) },
  e = { "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", "Goto the definition of the word under the cursor", unpack(default_opts) },
  t = { "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", "Goto the definition of the type under the cursor", unpack(default_opts) },
  s = { "<cmd>:Telescope persisted<CR>", "Show all sessions and local if there's a need of that", unpack(default_opts) },
}

local find_shortcuts = {
  name = "Word find",
  c = { ":noh<CR>", "Clear the last search highlight", unpack(default_opts) },
}

local mdpreview_shortcuts = {
  name = "Markdown Preview",
  t = { ":MarkdownPreviewToggle<CR>", "Toggle the markdown preview", unpack(default_opts) },
}

local text_management = {
  name = "Text Management",
  s = { ":keepjumps normal! ggVG<CR>", "Select all text using Control + a ", unpack(default_opts) },
}

local window_management = {
  name = "Window Management",
  h = { ":split<CR>", "Split the buffer horizontally", unpack(default_opts) },
  v = { ":vsplit<CR>", "Split the buffer vertically", unpack(default_opts) },
  q = { "<C-w>o", "Close all splitted buffers but the active one, try <C-w>o if doesn't work", unpack(default_opts) },
  w = { "<cmd>resize +10<CR>", "Increase window size to up", unpack(default_opts) },
  s = { "<cmd>resize -10<CR>", "Increase window size to down", unpack(default_opts) },
  a = { "<cmd>vertical resize +10<CR>", "Increase window size to left", unpack(default_opts) },
  d = { "<cmd>vertical resize -10<CR>", "Increase window size to right", unpack(default_opts) },
  k = { "<C-w>k", "Move the cursor for the upper window use <A-up>", unpack(default_opts) },
  j = { "<C-w>j", "Move the cursor for the bottom window use <A-down>", unpack(default_opts) },
  g = { "<C-w>h", "Move the cursor for the upper window use <A-left>", unpack(default_opts) },
  l = { "<C-w>l", "Move the cursor for the upper window use <A-right>", unpack(default_opts) },
}

local coc_shortcuts = {
  name = "Coc",
  i = { ":OR<CR>", "Organize the imports", unpack(default_opts) },
}

which_key.register({
  f = files_shortcuts,
  w = which_key_shortcuts,
  e = explorer_shortcuts,
  l = lazygit_shortcuts,
  t = telescope_shortcuts,
  s = find_shortcuts,
  m = mdpreview_shortcuts,
  x = text_management,
  p = window_management,
  c = coc_shortcuts,
}, { prefix = "<leader>", mode = "n" })



which_key.setup(which_key_opts)

return which_key
