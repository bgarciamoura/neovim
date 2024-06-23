local cursoline = require("nvim-cursorline")

cursoline.setup({
  cursorline = {
    enable = false,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 2,
    hl = { underline = true },
  },
})

return cursoline
