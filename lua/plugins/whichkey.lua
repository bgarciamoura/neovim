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
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
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
  e = { ":Lexplore<CR>", "Open a Side File Explorer On Current Path", unpack(default_opts) },
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
-- " Using Lua functions
-- nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
-- nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

local telescope_shortcuts = {
  name = "Telescope",
  f = { "<cmd>lua require('telescope.builtin').find_files()<CR>", "Find current folder files using Telescope",        unpack(default_opts) },
  g = { "<cmd>lua require('telescope.builtin').live_grep()<CR>",  "Grepping using Telescope",                         unpack(default_opts) },
  b = { "<cmd>lua require('telescope.builtin').buffers()<CR>",    "Find in opened buffers using Telescope",           unpack(default_opts) },
  h = { "<cmd>lua require('telescope.builtin').help_tags()<CR>",  "Find help in plugins/neovim docs using Telescope", unpack(default_opts) },
}


which_key.register({
  f = files_shortcuts,
  w = which_key_shortcuts,
  e = explorer_shortcuts,
  l = lazygit_shortcuts,
  t = telescope_shortcuts,
}, { prefix = "<leader>", mode = "n" })



which_key.setup(which_key_opts)

return which_key
