return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true, -- Habilita `git blame` na linha atual
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- Blame no final da linha
        delay = 500,       -- Tempo de espera para mostrar o blame
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    })
  end,
}
