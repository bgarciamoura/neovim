return {
  "otavioschwanck/arrow.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    show_icons = true,
    leader_key = ";",
    buffer_leader_key = "m",
  },
}
