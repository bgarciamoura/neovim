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
      -- Groups
      { "<leader>f", group = "Find",     icon = "\u{f002}"  },  --
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
      { "<leader>e", group = "Explorer", icon = "\u{f07b}"  },  --

      -- LSP
      { "<leader>ld", desc = "Go to definition" },
      { "<leader>lr", desc = "References" },
      { "<leader>ln", desc = "Rename" },
      { "<leader>la", desc = "Code action" },
      { "<leader>lf", desc = "Format" },
      { "<leader>li", desc = "LSP info" },
      { "<leader>lh", desc = "Hover" },
      { "<leader>ls", desc = "Signature help" },
      { "<leader>ll", desc = "Line diagnostics" },
      { "<leader>lt", desc = "Type definition" },

      -- Find
      { "<leader>ff", desc = "Find files" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fb", desc = "Buffers" },
      { "<leader>fh", desc = "Help tags" },
      { "<leader>ft", desc = "Todo comments" },
      { "<leader>fd", desc = "Diagnostics" },
      { "<leader>fr", desc = "Recent files" },
      { "<leader>fs", desc = "Document symbols" },
      { "<leader>fw", desc = "Grep word under cursor" },
      { "<leader>fR", desc = "Find and Replace" },
      { "<leader>fW", desc = "Replace word under cursor" },

      -- Explorer
      { "<leader>ef", desc = "Reveal current file" },
      { "<leader>eg", desc = "Git status" },
      { "<leader>eb", desc = "Buffers" },

      -- Git
      { "<leader>gg", desc = "Lazygit" },
      { "<leader>gb", desc = "Toggle blame" },
      { "<leader>gp", desc = "Preview hunk" },
      { "<leader>gs", desc = "Stage hunk" },
      { "<leader>gr", desc = "Reset hunk" },
      { "<leader>gS", desc = "Stage buffer" },
      { "<leader>gR", desc = "Reset buffer" },
      { "<leader>gd", desc = "Diff this" },

      -- Debug
      { "<leader>db", desc = "Toggle breakpoint" },
      { "<leader>dB", desc = "Conditional breakpoint" },
      { "<leader>dc", desc = "Continue" },
      { "<leader>di", desc = "Step into" },
      { "<leader>do", desc = "Step over" },
      { "<leader>dO", desc = "Step out" },
      { "<leader>du", desc = "Toggle DAP UI" },
      { "<leader>dr", desc = "Toggle REPL" },
      { "<leader>dl", desc = "Run last" },
      { "<leader>dt", desc = "Terminate" },

      -- Terminal
      { "<leader>th", desc = "Horizontal terminal" },
      { "<leader>tv", desc = "Vertical terminal" },
      { "<leader>tf", desc = "Float terminal" },

      -- Tests
      { "<leader>nr", desc = "Run nearest test" },
      { "<leader>nf", desc = "Run file tests" },
      { "<leader>ns", desc = "Run test suite" },
      { "<leader>no", desc = "Open output" },
      { "<leader>nS", desc = "Toggle summary" },
      { "<leader>nw", desc = "Watch file" },

      -- Run
      { "<leader>rb", desc = "Bruno run" },
      { "<leader>re", desc = "Bruno environment" },
      { "<leader>rs", desc = "Bruno search" },
      { "<leader>rt", desc = "Overseer toggle" },
      { "<leader>rr", desc = "Overseer run" },

      -- Session
      { "<leader>ss", desc = "Save session" },
      { "<leader>sr", desc = "Restore session" },
      { "<leader>sd", desc = "Delete session" },

      -- Buffers
      { "<leader>bd", desc = "Delete buffer" },
      { "<leader>bn", desc = "Next buffer" },
      { "<leader>bp", desc = "Previous buffer" },
      { "<leader>bD", desc = "Delete all buffers" },

      -- Markdown
      { "<leader>mp", desc = "Markdown preview" },
      { "<leader>ms", desc = "Stop preview" },
      { "<leader>mr", desc = "Toggle render" },

      -- Notebook
      { "<leader>oi", desc = "Initialize Molten" },
      { "<leader>or", desc = "Evaluate operator" },
      { "<leader>ol", desc = "Evaluate line" },
      { "<leader>oa", desc = "Re-evaluate all" },
      { "<leader>on", desc = "Next cell" },
      { "<leader>op", desc = "Previous cell" },
      { "<leader>od", desc = "Delete cell" },

      -- Docker
      { "<leader>kl", desc = "LazyDocker" },
    },
  },
}
