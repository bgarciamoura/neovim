return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,

        source_selector = {
          winbar = true,
          statusline = false,
          sources = {
            { source = "filesystem",  display_name = " \u{f0c5} Files " },
            { source = "buffers",     display_name = " \u{f0c5} Buffers " },
            { source = "git_status",  display_name = " \u{f126} Git " },
          },
        },

        default_component_configs = {
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
          },
          git_status = {
            symbols = {
              added     = " ",
              modified  = " ",
              deleted   = "✖ ",
              renamed   = "󰁕 ",
              untracked = " ",
              ignored   = " ",
              unstaged  = "󰄱 ",
              staged    = " ",
              conflict  = " ",
            },
          },
        },

        window = {
          position = "left",
          width = 35,
          mappings = {
            ["<space>"] = "none",
          },
        },

        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = {
              "node_modules",
              "__pycache__",
              ".venv",
              ".git",
            },
            never_show = {
              ".DS_Store",
              "thumbs.db",
            },
          },
        },
      })
    end,
  },
}
