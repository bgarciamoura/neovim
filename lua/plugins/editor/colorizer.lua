return {
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        "css",
        "scss",
        "html",
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "lua",
        "*",
      })
    end,
  },
}
