return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      -- Cmdline popup
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {},
        format = {
          cmdline       = { pattern = "^:", icon = "", lang = "vim" },
          search_down   = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up     = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter        = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua           = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help          = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
          input         = { view = "cmdline_input", icon = "󰥻 " },
        },
      },

      -- Messages routed to notify
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },

      -- Popup notify styling
      notify = {
        enabled = true,
        view = "notify",
      },

      -- LSP overrides
      lsp = {
        -- Progress disabled — fidget handles it
        progress = {
          enabled = false,
        },
        -- Override hover/signature docs with proper markdown rendering
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = true,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
          view = nil,
          opts = {},
        },
        message = {
          enabled = true,
          view = "notify",
          opts = {},
        },
        documentation = {
          view = "hover",
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },

      -- Presets
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
        inc_rename = false,
      },

      -- Views
      views = {
        cmdline_popup = {
          position = {
            row = "50%",
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "FloatBorder",
            },
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "FloatBorder",
            },
          },
        },
      },

      routes = {
        -- Suppress "written" messages
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d fewer lines" },
              { find = "%d more lines" },
            },
          },
          opts = { skip = true },
        },
        -- Send long messages to split
        {
          filter = { event = "msg_show", min_height = 20 },
          view = "messages",
        },
      },
    },
    config = function(_, opts)
      -- Make sure vim.notify is set up before noice loads
      require("noice").setup(opts)
    end,
  },
}
