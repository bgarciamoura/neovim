return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    'nvim-neotest/neotest-jest',
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-jest')({
          jestCommand = "pnpm jest",
          -- jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
          vim.api.nvim_set_keymap("n", "<leader>jw",
            "<cmd>lua require('neotest').run.run({ jestCommand = 'pnpx jest --watch ' })<cr>", {})
        }),
      },

    })
  end,
  -- vim.api.nvim_set_keymap("n", "<leader>js", "<cmd>lua require('neotest').run.stop()<cr>", {}),
  -- vim.api.nvim_set_keymap("n", "<leader>jr", "<cmd>lua require('neotest').run.run()<cr>", {}),
  -- vim.api.nvim_set_keymap("n", "<leader>jf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", {}),
  -- vim.api.nvim_set_keymap("n", "<leader>jo", "<cmd>lua require('neotest').output.open()<cr>", {}),
  -- vim.api.nvim_set_keymap("n", "<leader>ju", "<cmd>lua require('neotest').summary.toggle()<cr>", {}),
  -- vim.api.nvim_set_keymap("n", "<leader>jp", "<cmd>lua require('neotest').jump.prev({status = 'failed'})<cr>", {}),
  -- vim.api.nvim_set_keymap("n", "<leader>jn", "<cmd>lua require('neotest').jump.next({status = 'failed'})<cr>", {}),

}
