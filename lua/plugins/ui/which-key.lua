return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "",
    },
    spec = {
      { "<leader>f", group = "Find", icon = " " },
      { "<leader>e", group = "Explorer", icon = " " },
      { "<leader>l", group = "LSP", icon = " " },
      { "<leader>g", group = "Git", icon = " " },
      { "<leader>d", group = "Debug", icon = " " },
      { "<leader>t", group = "Terminal", icon = " " },
      { "<leader>n", group = "Tests", icon = " " },
      { "<leader>r", group = "Run", icon = " " },
      { "<leader>s", group = "Session", icon = " " },
      { "<leader>b", group = "Buffers", icon = " " },
      { "<leader>m", group = "Markdown", icon = " " },
      { "<leader>o", group = "Notebook", icon = " " },
      { "<leader>k", group = "Docker", icon = " " },
    },
  },
}
