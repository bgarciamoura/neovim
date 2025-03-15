local vim = vim

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  config = function()
    require("persistence").setup({
      dir = vim.fn.stdpath("data") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize" },
    })

    local group = vim.api.nvim_create_augroup("user-persistence", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "PersistenceSavePre",
      callback = function()
        if vim.bo.filetype == "alpha" then
          vim.cmd("AlphaClose")
        end
        if vim.fn.exists(":Neotree") == 2 then
          vim.cmd("Neotree close")
        end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "PersistenceLoadPost",
      callback = function()
        vim.cmd("Neotree show") -- Abre o painel do NvimTree
      end,
    })
  end,
}
