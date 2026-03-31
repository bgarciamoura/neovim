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
            folder_closed = "\u{f07b}",  --
            folder_open   = "\u{f07c}",  --
            folder_empty  = "\u{f115}",  --
          },
          git_status = {
            symbols = {
              added     = "\u{f055} ",   --
              modified  = "\u{f06a} ",   --
              deleted   = "\u{2716} ",   -- ✖
              renamed   = "\u{db80}\u{dc55} ", -- 󰁕
              untracked = "\u{f128} ",   --
              ignored   = "\u{f05e} ",   --
              unstaged  = "\u{db80}\u{dd31} ", -- 󰄱
              staged    = "\u{f00c} ",   --
              conflict  = "\u{f0e7} ",   --
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
