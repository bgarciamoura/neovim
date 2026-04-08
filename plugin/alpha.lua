-- Dashboard

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

-- Header
dashboard.section.header.val = {
  [[                                                                   ]],
  [[      ████ ██████           █████      ██                    ]],
  [[     ███████████             █████                            ]],
  [[     █████████ ███████████████████ ███   ███████████  ]],
  [[    █████████  ███    █████████████ █████ ██████████████  ]],
  [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
  [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
  [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
  [[                                                                   ]],
}

-- Buttons
local function button(sc, icon, txt, keybind)
  local b = dashboard.button(sc, icon .. "  " .. txt, keybind)
  b.opts.hl = "AlphaButtons"
  b.opts.hl_shortcut = "AlphaShortcut"
  return b
end

dashboard.section.buttons.val = {
  button("f", "\u{f002}",  "Find File",          "<Cmd>Telescope find_files<CR>"),
  button("r", "\u{f017}",  "Recent Files",       "<Cmd>Telescope oldfiles<CR>"),
  button("g", "\u{f1d0}",  "Find Word",          "<Cmd>Telescope live_grep<CR>"),
  button("e", "\u{f07b}",  "File Explorer",      "<Cmd>Neotree toggle<CR>"),
  button("G", "\u{f126}",  "Lazygit",            "<Cmd>lua require('toggleterm.terminal').Terminal:new({cmd='lazygit',direction='float',float_opts={border='rounded'}}):toggle()<CR>"),
  button("n", "\u{f0f6}",  "New File",           "<Cmd>ene<CR>"),
  button("c", "\u{f013}",  "Config",             "<Cmd>e $MYVIMRC<CR>"),
  button("t", "\u{f0c3}",  "Run Tests",          "<Cmd>Neotest summary<CR>"),
  button("q", "\u{f2f5}",  "Quit",               "<Cmd>qa<CR>"),
}

-- Info section (plugins, version, startup time)
local info = {}

-- Neovim version
local v = vim.version()
table.insert(info, string.format("\u{e62b} v%d.%d.%d", v.major, v.minor, v.patch))

-- Plugin count
local pack_path = vim.fn.stdpath('data') .. '/site/pack'
local plugin_count = #vim.fn.glob(pack_path .. '/*/*/*', false, true)
table.insert(info, string.format("\u{f1b2} %d plugins", plugin_count))

-- Current directory
local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
table.insert(info, string.format("\u{f07b} %s", cwd))

dashboard.section.footer.val = {
  "",
  table.concat(info, "    "),
}
dashboard.section.footer.opts.hl = "AlphaFooter"
dashboard.section.header.opts.hl = "AlphaHeader"

-- Startup time (deferred, updates after VimEnter)
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  once = true,
  callback = function()
    vim.defer_fn(function()
      local stats = vim.fn.reltime(vim.g.start_time or vim.fn.reltime())
      -- Use lazy event stats if available, otherwise calculate
      local startuptime = vim.fn.reltimefloat(vim.fn.reltime(vim.fn.reltime(), stats))

      -- Try to read from --startuptime if available
      local ok, result = pcall(function()
        return vim.fn.execute('verbose messages')
      end)

      table.insert(info, string.format("\u{26a1} %.1fms", startuptime * 1000))
      dashboard.section.footer.val = {
        "",
        table.concat(info, "    "),
      }
      pcall(vim.cmd, 'AlphaRedraw')
    end, 50)
  end,
})

-- Layout
dashboard.opts.layout = {
  { type = "padding", val = 2 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 2 },
  dashboard.section.footer,
}

-- Highlight groups
vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#b4befe" })
vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#fab387", bold = true })
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6a6f87", italic = true })

-- Hide UI elements on dashboard
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
