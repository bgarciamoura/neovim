local vim = vim

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-web-devicons" },
  config = function()
    local function get_active_lsp()
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()
      local lsp_names = {}

      for _, client in ipairs(clients) do
        if client.attached_buffers[vim.api.nvim_get_current_buf()] then
          table.insert(lsp_names, client.name)
        end
      end

      return #lsp_names > 0 and "  " .. table.concat(lsp_names, ", ") or "No LSP"
    end

    local function plugin_shortcuts()
      return "[E] Explorer | [T] Trouble | [M] Mason"
    end

    require("lualine").setup({
      options = {
        theme = "ayu_mirage",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", path = 1 },
          {
            "copilot",
            cond = function()
              return vim.g.copilot_enabled
            end,
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { plugin_shortcuts, "progress" },
        lualine_z = { "location" },
      },
      extensions = { "nvim-tree", "trouble", "mason" },
    })

    -- Mapeamentos para abrir os plugins rapidamente
    vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>t", ":Trouble diagnostics toggle<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>m", ":Mason<CR>", { noremap = true, silent = true })
  end,
}
