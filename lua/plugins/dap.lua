return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui", -- UI para depuração
			"jay-babu/mason-nvim-dap.nvim", -- Instalação automática de DAPs com Mason
			"theHamsta/nvim-dap-virtual-text", -- Exibição de variáveis inline
			"nvim-telescope/telescope-dap.nvim", -- Integração com Telescope
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_virtual_text = require("nvim-dap-virtual-text")

			-- Configuração do UI para DAP
			dapui.setup({
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
			})
			dap_virtual_text.setup({
				enabled = true,
				commented = true,
			})

			-- Integrar com eventos do dap
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Instalar adaptadores necessários via Mason
			require("mason-nvim-dap").setup({
				ensure_installed = { "js-debug-adapter" }, -- Suporte para JS, TS, React e Angular
				automatic_installation = true,
			})

			-- Configuração de adaptadores para depuração
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = 9229,
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"9229",
					},
				},
			}

			dap.adapters["pwa-chrome"] = {
				type = "server",
				host = "localhost",
				port = 9222,
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"9222",
					},
				},
			}

			-- Configuração para TypeScript, React e Angular
			dap.configurations.typescript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Iniciar TypeScript com Node",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
				},
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Depurar no Chrome",
					url = "http://localhost:4200", -- Altere conforme necessário
					webRoot = "${workspaceFolder}",
				},
			}

			dap.configurations.javascript = dap.configurations.typescript
			dap.configurations.typescriptreact = dap.configurations["typescript"]
			dap.configurations.javascriptreact = dap.configurations["typescript"]

			-- Atalhos úteis para depuração
			local map = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }

			-- Configuração do Telescope para integração com DAP
			require("telescope").load_extension("dap")
		end,
	},
}
