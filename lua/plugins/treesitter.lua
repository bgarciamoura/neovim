local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "html",
    "css",
    "javascript",
    "typescript",
    "markdown",
  },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  auto_install = true,
})

return treesitter
