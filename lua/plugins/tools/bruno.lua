return {
  {
    "romek-codes/bruno.nvim",
    cmd = { "BrunoRun", "BrunoEnv", "BrunoSearch" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      picker                    = "telescope",
      show_formatted_output     = true,
      suppress_formatting_errors = false,
      collection_paths          = {},
    },
  },
}
