return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  config = function()
    require("render-markdown").setup({
      -- Configurações padrões
      options = {
        -- Atalhos
        mappings = {
          -- Atalho para renderizar o markdown
          render = "<leader>rm",
          -- Atalho para renderizar o markdown no modo visual
          render_visual = "<leader>rv",
          -- Atalho para renderizar o markdown no modo visual
          render_all = "<leader>ra",
        },
        -- Configurações do markdown
        markdown = {
          -- Configurações do markdown
          frontmatter = {
            -- Atalho para renderizar o markdown
            render = "<leader>rm",
            -- Atalho para renderizar o markdown no modo visual
            render_visual = "<leader>rv",
            -- Atalho para renderizar o markdown no modo visual
            render_all = "<leader>ra",
          },
        },
      },
    })
  end,
}
