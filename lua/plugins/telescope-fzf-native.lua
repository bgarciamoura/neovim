return {
  "nvim-telescope/telescope-fzf-native.nvim",
  build = "make",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension("fzf")
  end,
}
