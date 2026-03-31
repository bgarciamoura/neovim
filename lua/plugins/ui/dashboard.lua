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

      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find File",       "<cmd>Telescope find_files<cr>"),
        dashboard.button("r", " " .. " Recent Files",    "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("g", " " .. " Find Word",       "<cmd>Telescope live_grep<cr>"),
        dashboard.button("s", "󰒲 " .. " Restore Session", "<cmd>lua require('persistence').load()<cr>"),
        dashboard.button("c", " " .. " Config",          "<cmd>e $MYVIMRC<cr>"),
        dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd>Lazy<cr>"),
        dashboard.button("q", " " .. " Quit",            "<cmd>qa<cr>"),
      }

      -- Footer
      local function footer()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        return {
          "⚡ Neovim loaded "
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
      dashboard.section.buttons.opts.hl = "AlphaButtons"

      -- Layout
      dashboard.opts.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- Set custom highlight groups
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local ok, cp = pcall(require, "catppuccin.palettes")
          if ok then
            local palette = cp.get_palette("mocha")
            vim.api.nvim_set_hl(0, "AlphaHeader",  { fg = palette.blue,    bold = true })
            vim.api.nvim_set_hl(0, "AlphaButtons", { fg = palette.lavender })
            vim.api.nvim_set_hl(0, "AlphaFooter",  { fg = palette.subtext0, italic = true })
          else
            vim.api.nvim_set_hl(0, "AlphaHeader",  { fg = "#89b4fa", bold = true })
            vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#b4befe" })
            vim.api.nvim_set_hl(0, "AlphaFooter",  { fg = "#a6adc8", italic = true })
          end
        end,
      })

      -- Trigger highlight setup immediately
      vim.cmd("doautocmd ColorScheme")

      -- Don't show statusline or tabline on alpha
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
