return {
  -- ── nvim-dap ───────────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ── Signs ──────────────────────────────────────────────────────────────
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = " ", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = " ", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
      )

      -- ── JS/TS Adapter (pwa-node via js-debug-adapter) ─────────────────────
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      -- Reuse pwa-node adapter for all JS/TS variants
      for _, adapter in ipairs({ "node", "chrome", "pwa-chrome" }) do
        dap.adapters[adapter] = dap.adapters["pwa-node"]
      end

      -- ── JS/TS/TSX/JSX Configurations ──────────────────────────────────────
      local js_config = {
        -- Launch file
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        -- Attach to process
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
      }

      for _, ft in ipairs({ "javascript", "typescript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[ft] = js_config
      end

      -- ── Python Adapter (debugpy via Mason) ────────────────────────────────
      local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe"

      dap.adapters.python = {
        type = "executable",
        command = debugpy_path,
        args = { "-m", "debugpy.adapter" },
      }

      -- ── Python Configuration ──────────────────────────────────────────────
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Prefer local .venv on Windows, fall back to system python
            local venv_python = vim.fn.getcwd() .. "/.venv/Scripts/python.exe"
            if vim.fn.executable(venv_python) == 1 then
              return venv_python
            end
            return "python"
          end,
        },
      }

      -- ── Auto open/close DAP UI ────────────────────────────────────────────
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- ── nvim-dap-ui ───────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    opts = {
      icons = {
        expanded = "▾",
        collapsed = "▸",
        current_frame = "▸",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
      floating = {
        border = "rounded",
      },
    },
  },

  -- ── nvim-dap-virtual-text ─────────────────────────────────────────────────
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {
      commented = true,
    },
  },
}
