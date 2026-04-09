-- Test runner

local ok, neotest = pcall(require, 'neotest')
if not ok then return end

local adapters = {}
local ok_jest, neotest_jest = pcall(require, 'neotest-jest')
if ok_jest then
  table.insert(adapters, neotest_jest({
    jestCommand = 'npx jest',
    cwd = function() return vim.fn.getcwd() end,
  }))
end
local ok_vitest, neotest_vitest = pcall(require, 'neotest-vitest')
if ok_vitest then table.insert(adapters, neotest_vitest) end
local ok_python, neotest_python = pcall(require, 'neotest-python')
if ok_python then
  table.insert(adapters, neotest_python({
    runner = 'pytest',
    python = function()
      local venv = vim.fn.getcwd() .. '/.venv/Scripts/python.exe'
      if vim.fn.filereadable(venv) == 1 then
        return venv
      end
      return 'python'
    end,
  }))
end
local ok_dart, neotest_dart = pcall(require, 'neotest-dart')
if ok_dart then
  table.insert(adapters, neotest_dart({ command = 'flutter' }))
end

neotest.setup({
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
  adapters = adapters,
})
