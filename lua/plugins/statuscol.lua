local statuscol = require("statuscol")
local builtin = require("statuscol.builtin")

statuscol.setup {
  setopt = true,
  thousands = false,
  relculright = false,
  ft_ignore = {
    "neo-tree",
  },
  bt_ignore = nil,
  segments = {
    { text = { " %s" },                      click = "v:lua.ScSa" },
    { text = { " ", builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
    {
      text = {
        builtin.foldfunc,
        " ",
      },
      click = "v:lua.ScFa",
    },
  },
  clickmod = "c",
  -- "a" for Alt, "c" for Ctrl and "m" for Meta.
  clickhandlers = { -- builtin click handlers
    Lnum                   = builtin.lnum_click,
    FoldClose              = builtin.foldclose_click,
    FoldOpen               = builtin.foldopen_click,
    FoldOther              = builtin.foldother_click,
    DapBreakpointRejected  = builtin.toggle_breakpoint,
    DapBreakpoint          = builtin.toggle_breakpoint,
    DapBreakpointCondition = builtin.toggle_breakpoint,
    ["diagnostic/signs"]   = builtin.diagnostic_click,
    gitsigns               = builtin.gitsigns_click,
  },


}

