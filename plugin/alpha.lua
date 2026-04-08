-- Dashboard

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

-- Header
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
local function button(sc, icon, txt, keybind)
  local b = dashboard.button(sc, icon .. "  " .. txt, keybind)
  b.opts.hl = "AlphaButtons"
  b.opts.hl_shortcut = "AlphaShortcut"
  return b
end

dashboard.section.buttons.val = {
  button("f", "\u{f002}",  "Find File",       "<Cmd>Telescope find_files<CR>"),
  button("r", "\u{f017}",  "Recent Files",    "<Cmd>Telescope oldfiles<CR>"),
  button("g", "\u{f1d0}",  "Find Word",       "<Cmd>Telescope live_grep<CR>"),
  button("c", "\u{f013}",  "Config",          "<Cmd>e $MYVIMRC<CR>"),
  button("q", "\u{f2f5}",  "Quit",            "<Cmd>qa<CR>"),
}

-- Footer
dashboard.section.footer.val = { "" }
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

-- Highlight groups
vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89b4fa", bold = true })
vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#b4befe" })
vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#fab387", bold = true })
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#a6adc8", italic = true })

-- Hide statusline on dashboard
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    vim.opt_local.showtabline = 0
    vim.opt_local.laststatus = 0
  end,
})

vim.api.nvim_create_autocmd("BufUnload", {
  pattern = "<buffer>",
  callback = function()
    vim.opt.laststatus = 3
  end,
})

alpha.setup(dashboard.opts)
