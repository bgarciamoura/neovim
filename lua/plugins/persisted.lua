local persisted = require("persisted")

persisted.setup({
  save_dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
  autoload = true,
  on_autoload_no_session = function()
    vim.notify("No existing session to load.")
  end
})

return persisted

