return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Header ASCII art
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }

      -- Buttons with Nerd Font icons
      -- Using explicit Unicode codepoints to ensure icons render
      local function button(sc, icon, txt, keybind)
        local b = dashboard.button(sc, icon .. "  " .. txt, keybind)
        b.opts.hl = "AlphaButtons"
        b.opts.hl_shortcut = "AlphaShortcut"
        return b
      end

      dashboard.section.buttons.val = {
        button("f", "\u{f002}",  "Find File",       "<cmd>Telescope find_files<cr>"),       --
        button("r", "\u{f017}",  "Recent Files",    "<cmd>Telescope oldfiles<cr>"),          --
        button("g", "\u{f1d0}",  "Find Word",       "<cmd>Telescope live_grep<cr>"),         --
        button("s", "\u{f0e2}",  "Restore Session", "<cmd>SessionRestore<cr>"),              --
        button("c", "\u{f013}",  "Config",          "<cmd>e $MYVIMRC<cr>"),                  --
        button("l", "\u{f49e}",  "Lazy",            "<cmd>Lazy<cr>"),                        --
        button("q", "\u{f2f5}",  "Quit",            "<cmd>qa<cr>"),                          --
      }

      -- Footer
      local function footer()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        return {
          "\u{26a1} Neovim loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms",
        }
      end

      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.section.header.opts.hl = "AlphaHeader"

      -- Layout
      dashboard.opts.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- Custom highlight groups
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local ok, cp = pcall(require, "catppuccin.palettes")
          if ok then
            local palette = cp.get_palette("mocha")
            vim.api.nvim_set_hl(0, "AlphaHeader", { fg = palette.blue, bold = true })
            vim.api.nvim_set_hl(0, "AlphaButtons", { fg = palette.lavender })
            vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = palette.peach, bold = true })
            vim.api.nvim_set_hl(0, "AlphaFooter", { fg = palette.subtext0, italic = true })
          else
            vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89b4fa", bold = true })
            vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#b4befe" })
            vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#fab387", bold = true })
            vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#a6adc8", italic = true })
          end
        end,
      })
      vim.cmd("doautocmd ColorScheme")

      -- Hide statusline on dashboard
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt_local.showtabline = 0
          vim.opt_local.laststatus = 0
        end,
      })
      vim.api.nvim_create_autocmd("BufUnload", {
        buffer = 0,
        callback = function()
          vim.opt.showtabline = 2
          vim.opt.laststatus = 3
        end,
      })

      alpha.setup(dashboard.opts)
    end,
  },
}
