local persisted = require("persisted")

persisted.setup({
  save_dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
  autoload = false,
  ignore_dirs = { ".git", "node_modules", "~", "/" },
  on_autoload_no_session = function()
    vim.notify("No existing session to load.")
  end
})

return persisted
