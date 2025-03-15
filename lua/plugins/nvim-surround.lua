return {
  "kylechui/nvim-surround",
  version = "*", -- Sempre usa a última versão estável
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup()
  end,
}
