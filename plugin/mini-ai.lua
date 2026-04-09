-- Enhanced textobjects (no nvim-treesitter dependency)
-- Built-in defaults: af/if (function call), aa/ia (argument),
-- a)/i), a]/i], a}/i}, a"/i", a'/i', a`/i`, at/it (tag)

local ok, mini_ai = pcall(require, 'mini.ai')
if not ok then return end

mini_ai.setup({
  n_lines = 500,
})
