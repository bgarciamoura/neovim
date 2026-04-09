-- Debug Adapter Protocol

local ok, dap = pcall(require, 'dap')
if not ok then return end
local dapui = require('dapui')

-- Signs
vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = ' ', texthl = 'DapBreakpointCondition' })
vim.fn.sign_define('DapLogPoint', { text = ' ', texthl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '󰁕 ', texthl = 'DapStopped', linehl = 'DapStoppedLine' })
vim.fn.sign_define('DapBreakpointRejected', { text = ' ', texthl = 'DapBreakpointRejected' })

-- JS/TS Adapter (pwa-node via js-debug-adapter)
local js_debug_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter'

dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = { js_debug_path .. '/js-debug/src/dapDebugServer.js', '${port}' },
  },
}

for _, adapter in ipairs({ 'node', 'chrome', 'pwa-chrome' }) do
  dap.adapters[adapter] = dap.adapters['pwa-node']
end

-- JS/TS Configurations
local js_config = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
    resolveSourceMapLocations = {
      '${workspaceFolder}/**',
      '!**/node_modules/**',
    },
  },
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach to process',
    processId = require('dap.utils').pick_process,
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    resolveSourceMapLocations = {
      '${workspaceFolder}/**',
      '!**/node_modules/**',
    },
  },
}

for _, ft in ipairs({ 'javascript', 'typescript', 'typescriptreact', 'javascriptreact' }) do
  dap.configurations[ft] = js_config
end

-- Python Adapter (debugpy via Mason)
local debugpy_path = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/Scripts/python.exe'

dap.adapters.python = {
  type = 'executable',
  command = debugpy_path,
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = function()
      local venv_python = vim.fn.getcwd() .. '/.venv/Scripts/python.exe'
      if vim.fn.executable(venv_python) == 1 then
        return venv_python
      end
      return 'python'
    end,
  },
}

-- DAP UI
dapui.setup({
  icons = {
    expanded = '▾',
    collapsed = '▸',
    current_frame = '▸',
  },
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 0.25 },
        { id = 'breakpoints', size = 0.25 },
        { id = 'stacks', size = 0.25 },
        { id = 'watches', size = 0.25 },
      },
      position = 'left',
      size = 40,
    },
    {
      elements = {
        { id = 'repl', size = 0.5 },
        { id = 'console', size = 0.5 },
      },
      position = 'bottom',
      size = 10,
    },
  },
  floating = { border = 'rounded' },
})

-- Virtual text
local ok_vt, vt = pcall(require, 'nvim-dap-virtual-text')
if ok_vt then vt.setup({ commented = true }) end

-- Auto open/close DAP UI
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
