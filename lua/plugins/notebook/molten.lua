return {
  -- Molten: interactive notebook execution
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    ft = { "python", "quarto" },
    build = ":UpdateRemotePlugins",
    dependencies = {
      "3rd/image.nvim",
    },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
  },

  -- Image rendering backend (WezTerm supports kitty protocol)
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty",
      max_width = 100,
      max_height = 12,
    },
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
