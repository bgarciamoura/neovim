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
          theme = "oasis",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "alpha", "dashboard", "starter" },
          },
          always_divide_middle = true,
          refresh = { statusline = 100 },
        },

        sections = {
          lualine_a = {
            {
              "mode",
              separator = { left = "", right = "" },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "",
              separator = { right = "" },
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
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = {
                error = " ",
                warn = " ",
                hint = " ",
                info = " ",
              },
              colored = true,
            },
          },

          lualine_x = {
            { lsp_clients },
            { "filetype" },
          },
          lualine_y = {
            {
              "progress",
              separator = { left = "" },
            },
          },
          lualine_z = {
            {
              "location",
              separator = { left = "", right = "" },
              padding = { left = 1, right = 1 },
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
              symbols = { modified = " ●", readonly = " " },
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
