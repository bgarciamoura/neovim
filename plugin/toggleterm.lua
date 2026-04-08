-- Terminal management

require('toggleterm').setup({
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    elseif term.direction == 'vertical' then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
  open_mapping = false,
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = false,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true,
  shell = 'nu',
  float_opts = {
    border = 'rounded',
    winblend = 0,
  },
})
