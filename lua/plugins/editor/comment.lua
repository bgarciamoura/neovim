return {
  -- Context-aware commentstring (required by Comment.nvim for JSX/TSX)
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  -- Comment.nvim with treesitter context integration
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
}
