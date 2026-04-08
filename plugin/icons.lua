-- Material icons (must load before plugins that use nvim-web-devicons)

local ok, material_icon = pcall(require, 'nvim-material-icon')
if not ok then return end

require('nvim-web-devicons').setup({
  override = material_icon.get_icons(),
})
