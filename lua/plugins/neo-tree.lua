local neotree = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true, -- Fecha se for o único buffer aberto
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        hijack_netrw = true,       -- Substitui o explorador de arquivos padrão
        follow_current_file = enabled, -- Expande automaticamente para o arquivo atual
        use_libuv_file_watcher = true, -- Atualiza automaticamente ao modificar arquivos
        filtered_items = {
          visible = true,
          hide_dotfiles = false, -- Se quiser ocultar arquivos ocultos (como .git)
          hide_gitignored = true,
          hide_by_name = { "node_modules", ".cache" },
        },
      },
      window = {
        use_default_mappings = true,
        position = "left",
        width = 35,
        mappings = {
          ["<CR>"] = "open", -- Abrir arquivo com Enter
          ["o"] = "open",   -- Atalho alternativo como no VSCode
          ["s"] = "open_split", -- Abrir em split horizontal
          ["v"] = "open_vsplit", -- Abrir em split vertical
          ["t"] = "open_tabnew", -- Abrir em nova aba
          ["<C-r>"] = "refresh", -- Atualizar árvore
          ["h"] = "close_node", -- Fechar diretório
          ["l"] = "open",   -- Abrir diretório/arquivo
        },
      },
      default_component_configs = {
        indent = {
          padding = 1, -- Ajusta espaçamento visual
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        modified = {
          symbol = "●", -- Indica arquivo modificado
        },
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "➜",
            untracked = "★",
            ignored = "◌",
            unstaged = "!",
            staged = "✓",
            conflict = "",
          },
        },
      },
    })

    -- Abrir o NeoTree automaticamente no startup
    -- vim.cmd([[autocmd VimEnter * Neotree show]])
  end,
}

-- vim.cmd [[
--   highlight NeoTreeNormal guibg=#1e1e1e guifg=#d4d4d4
--   highlight NeoTreeNormalNC guibg=#1e1e1e guifg=#d4d4d4
--   highlight NeoTreeCursorLine guibg=#323232
--   highlight NeoTreeIndentMarker guifg=#5a5a5a
-- ]]

return neotree
