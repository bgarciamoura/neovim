vim.g._start_time = vim.loop.hrtime()

-- Silence vim.tbl_flatten deprecation from plugins (redirect to new API)
vim.tbl_flatten = function(t) return vim.iter(t):flatten():totable() end

require("config.options")
require("config.plugins")
require("config.autocmds")
require("config.keymaps")
require("config.snippets")
require("config.project")
