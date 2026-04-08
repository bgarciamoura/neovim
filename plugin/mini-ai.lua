-- Enhanced textobjects (pattern-based, no nvim-treesitter dependency)
-- Built-in: a)/i) parens, a]/i] brackets, a}/i} braces, a"/i" quotes
-- Custom: af/if function call, aa/ia argument (already built-in in mini.ai)

local ai = require('mini.ai')

ai.setup({
  -- Use built-in textobjects + pattern-based custom ones
  -- 'f' (function call) and 'a' (argument) are built-in defaults
  custom_textobjects = {
    -- Function body: from 'function' keyword to 'end' or closing brace
    F = ai.gen_spec.pattern('function[^(]*%b().-end', '^function[^(]*%b()%s*(.-)%s*end$'),
  },
  n_lines = 500,
})
