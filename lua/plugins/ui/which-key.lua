return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
    icons = {
      breadcrumb = "\u{00bb}",   -- »
      separator = "\u{279c}",    -- ➜
      group = "",
    },
    spec = {
      { "<leader>f", group = "Find",     icon = "\u{f002}"  },  --
      { "<leader>e", group = "Explorer", icon = "\u{f07b}"  },  --
      { "<leader>l", group = "LSP",      icon = "\u{f085}"  },  --
      { "<leader>g", group = "Git",      icon = "\u{f126}"  },  --
      { "<leader>d", group = "Debug",    icon = "\u{f188}"  },  --
      { "<leader>t", group = "Terminal", icon = "\u{f120}"  },  --
      { "<leader>n", group = "Tests",    icon = "\u{f0c3}"  },  --
      { "<leader>r", group = "Run",      icon = "\u{f04b}"  },  --
      { "<leader>s", group = "Session",  icon = "\u{f0e2}"  },  --
      { "<leader>b", group = "Buffers",  icon = "\u{f0c5}"  },  --
      { "<leader>m", group = "Markdown", icon = "\u{f48a}"  },  --
      { "<leader>o", group = "Notebook", icon = "\u{f02d}"  },  --
      { "<leader>k", group = "Docker",   icon = "\u{f21a}"  },  --
    },
  },
}
