-- 🔥 3. Como Usar o Spectre
-- 🔹 Modo Global (Buscar e Substituir no Projeto)
-- 1️⃣ Pressione <leader>sr para abrir o Spectre.
-- 2️⃣ Digite o termo a buscar na barra de pesquisa superior.
-- 3️⃣ Digite o novo termo na coluna "Replace".
-- 4️⃣ Pressione <C-Enter> para executar a substituição global.
--
-- 🔹 Caso queira buscar palavras específicas, use <leader>sw antes.
--
-- 🔹 Modo Local (Buscar e Substituir no Arquivo Atual)
-- 1️⃣ Pressione <leader>sf dentro do arquivo.
-- 2️⃣ Ele abrirá o Spectre focado apenas no arquivo atual.
-- 3️⃣ Digite o novo termo e pressione <C-Enter> para substituir.

return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Spectre",
  keys = {
    { "<leader>sr", "<cmd>Spectre<CR>", desc = "Abrir Spectre" },
    {
      "<leader>sw",
      function()
        require("spectre").open_visual({ select_word = true })
      end,
      desc = "Buscar palavra sob o cursor",
    },
    {
      "<leader>sf",
      function()
        require("spectre").open_file_search({ select_word = true })
      end,
      desc = "Buscar e substituir no arquivo atual",
    },
  },
  config = function()
    require("spectre").setup({
      color_devicons = true,
      live_update = true, -- Atualiza automaticamente enquanto digita
      result_padding = "│ ",
      line_sep_start = "────────────────────────────────────────",
      line_sep = "────────────────────────────────────────",
      default = {
        find = {
          cmd = "rg",
          options = { "--hidden", "--glob=!node_modules/*", "--glob=!dist/*" },
        },
      },
    })
  end,
}
