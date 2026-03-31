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
      -- Helper for Unicode codepoints above BMP (Lua \u{} doesn't support surrogates)
      local nr = vim.fn.nr2char

      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,

        source_selector = {
          winbar = true,
          statusline = false,
          sources = {
            { source = "filesystem", display_name = " " .. nr(0xf07b) .. " Files " },
            { source = "buffers", display_name = " " .. nr(0xf0c5) .. " Buffers " },
            { source = "git_status", display_name = " " .. nr(0xf126) .. " Git " },
          },
        },

        default_component_configs = {
          icon = {
            folder_closed = nr(0xf07b),
            folder_open = nr(0xf07c),
            folder_empty = nr(0xf115),
          },
          git_status = {
            symbols = {
              added = nr(0xf055) .. " ",
              modified = nr(0xf06a) .. " ",
              deleted = nr(0x2716) .. " ",
              renamed = nr(0x100055) .. " ",
              untracked = nr(0xf128) .. " ",
              ignored = nr(0xf05e) .. " ",
              unstaged = nr(0x100131) .. " ",
              staged = nr(0xf00c) .. " ",
              conflict = nr(0xf0e7) .. " ",
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
