-- Floating command line (requires cmdheight=0 set in options.lua)
-- ui2 must be explicitly enabled before tiny-cmdline can reposition the window.

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    -- Enable the experimental ui2 system that manages the cmdline as a floating window.
    -- Without this, Neovim renders the cmdline via the C layer and Lua hooks are bypassed.
    local ui2_ok, ui2 = pcall(require, 'vim._core.ui2')
    if ui2_ok and ui2.enable then
      ui2.enable({ enable = true })
    end

    -- Defer tiny-cmdline setup so ui2 has a chance to create the cmd window.
    vim.schedule(function()
      local ok, tc = pcall(require, 'tiny-cmdline')
      if not ok then return end

      tc.setup({
        width = 0.4,
        border = 'rounded',
      })
    end)
  end,
})
