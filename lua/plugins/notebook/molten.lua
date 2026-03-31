return {
  -- Molten: interactive notebook execution
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    ft = { "python", "quarto" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
  },

  -- Jupytext: convert .ipynb to editable formats
  {
    "GCBallesteros/jupytext.nvim",
    ft = { "ipynb" },
    opts = {
      style = "hydrogen",
      output_extension = "auto",
    },
  },
}
