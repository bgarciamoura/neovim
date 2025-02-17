return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- Dependência necessária
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Buscar arquivos" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Buscar texto no projeto" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Buscar buffers abertos" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Buscar na documentação do Neovim" },
    { "<leader>fs", "<cmd>Telescope git_status<CR>",  desc = "Ver alterações no Git" },
    { "<leader>fc", "<cmd>Telescope git_commits<CR>", desc = "Buscar commits" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true, -- Mostra arquivos ocultos
        },
        live_grep = {
          only_sort_text = true,
        },
      },
    })
  end,
}
