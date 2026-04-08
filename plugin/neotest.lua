-- Test runner

require('neotest').setup({
  icons = {
    failed = ' ',
    passed = ' ',
    running = ' ',
    skipped = ' ',
    unknown = ' ',
  },
  output = {
    enabled = true,
    open_on_run = true,
  },
  status = {
    enabled = true,
    signs = true,
    virtual_text = true,
  },
  adapters = {
    require('neotest-jest')({
      jestCommand = 'npx jest',
      cwd = function() return vim.fn.getcwd() end,
    }),
    require('neotest-vitest'),
    require('neotest-python')({
      runner = 'pytest',
      python = function()
        local venv = vim.fn.getcwd() .. '/.venv/Scripts/python.exe'
        if vim.fn.filereadable(venv) == 1 then
          return venv
        end
        return 'python'
      end,
    }),
    require('neotest-dart')({
      command = 'flutter',
    }),
  },
})
