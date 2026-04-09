-- Code action picker via telescope

local ok, tca = pcall(require, 'tiny-code-action')
if not ok then return end

tca.setup({
  backend = 'vim',
  picker = 'telescope',
})
