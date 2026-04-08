-- Textobjects via treesitter (replacement for nvim-treesitter-textobjects)
-- Provides: af/if (function), ac/ic (class), aa/ia (argument), and more

local ai = require('mini.ai')
local spec_treesitter = ai.gen_spec.treesitter

ai.setup({
  custom_textobjects = {
    f = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
    c = spec_treesitter({ a = '@class.outer', i = '@class.inner' }),
    a = spec_treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
    o = spec_treesitter({
      a = { '@conditional.outer', '@loop.outer' },
      i = { '@conditional.inner', '@loop.inner' },
    }),
  },
  n_lines = 500,
})
