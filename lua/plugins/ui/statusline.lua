return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return ""
        end
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return " " .. table.concat(names, ", ")
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "alpha", "dashboard", "starter" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },

        sections = {
          -- Left
          lualine_a = {
            {
              "mode",
              icon = "",
              separator = { left = "" },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "",
            },
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
          },

          -- Center
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = {
                modified = " ",
                readonly = " ",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
            {
              "diagnostics",
              sources = { "nvim_lsp", "nvim_diagnostic" },
              symbols = {
                error = " ",
                warn = " ",
                hint = " ",
                info = " ",
              },
              colored = true,
              update_in_insert = false,
              always_visible = false,
            },
          },

          -- Right
          lualine_x = {
            { lsp_clients },
            { "encoding" },
            { "filetype" },
          },
          lualine_y = {
            { "progress" },
          },
          lualine_z = {
            {
              "location",
              icon = "",
              separator = { right = "" },
            },
          },
        },

        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = {
                modified = " ",
                readonly = " ",
              },
            },
          },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },

        extensions = { "neo-tree", "lazy", "mason", "toggleterm" },
      })
    end,
  },
}
