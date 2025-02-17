return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter",
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Treesitter é necessário
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
