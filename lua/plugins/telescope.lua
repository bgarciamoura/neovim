local telescope = require("telescope")

telescope.load_extension("themes")

telescope.setup{
  defaults = { layout_strategy = "flex" },
  pickers = { 
    colorscheme = { 
      enable_preview = true,
      on_change = function()
        print("oi")
      end,
    } 
  }, 
  extensions = {
    themes = {
      enable_previewer = true,
      enable_live_preview = true,
      ignore = {},
      persist = {
        enabled = true,
      },
    },
  },
}



return telescope
