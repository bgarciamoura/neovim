return {
	-- Suporte específico para NestJS
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function(_, opts)
			require("luasnip.loaders.from_vscode").lazy_load()

			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node

			-- Adicionar snippets específicos para NestJS
			ls.add_snippets("typescript", {
				-- Módulo NestJS
				s("nmodule", {
					t("import { Module } from '@nestjs/common';"),
					t({ "", "" }),
					t("@Module({"),
					t({ "", "  imports: [" }),
					i(1, ""),
					t({ "", "  ]," }),
					t({ "", "  controllers: [" }),
					i(2, ""),
					t({ "", "  ]," }),
					t({ "", "  providers: [" }),
					i(3, ""),
					t({ "", "  ]," }),
					t({ "", "  exports: [" }),
					i(4, ""),
					t({ "", "  ]," }),
					t({ "", "}" }),
					t({ "", "export class " }),
					i(5, "Name"),
					t("Module {}"),
				}),

				-- Controller NestJS
				s("ncontroller", {
					t("import { Controller } from '@nestjs/common';"),
					t({ "", "" }),
					t("@Controller('"),
					i(1, "path"),
					t("')"),
					t({ "", "export class " }),
					i(2, "Name"),
					t("Controller {"),
					t({ "", "  constructor(" }),
					i(3, ""),
					t(") {}"),
					t({ "", "" }),
					t({ "", "}" }),
				}),

				-- GET Endpoint
				s("nget", {
					t("@Get('"),
					i(1, "path"),
					t("')"),
					t({ "", "async " }),
					i(2, "methodName"),
					t("("),
					i(3, ""),
					t(") {"),
					t({ "", "  " }),
					i(4, "return"),
					t({ "", "}" }),
				}),

				-- Service NestJS
				s("nservice", {
					t("import { Injectable } from '@nestjs/common';"),
					t({ "", "" }),
					t("@Injectable()"),
					t({ "", "export class " }),
					i(1, "Name"),
					t("Service {"),
					t({ "", "  constructor(" }),
					i(2, ""),
					t(") {}"),
					t({ "", "" }),
					t({ "", "}" }),
				}),
			})
		end,
	},

	-- Configuração para NestJS e outros frameworks Node.js
	{
		"mfussenegger/nvim-dap",
		dependencies = { "mxsdev/nvim-dap-vscode-js" },
		config = function()
			require("dap-vscode-js").setup({
				-- Use o debugger Node.js
				debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
			})

			-- Configuração específica para NestJS
			local dap = require("dap")
			dap.configurations.typescript = dap.configurations.typescript or {}
			table.insert(dap.configurations.typescript, {
				type = "pwa-node",
				request = "launch",
				name = "Debug NestJS",
				runtimeExecutable = "npm",
				runtimeArgs = { "run", "start:debug" },
				rootPath = "${workspaceFolder}",
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			})
		end,
	},

	-- Suporte avançado para Python (FastAPI, Django, Flask)
	{
		"mfussenegger/nvim-dap-python",
		ft = { "python" },
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

			-- Configuração para FastAPI
			local dap = require("dap")
			dap.configurations.python = dap.configurations.python or {}
			table.insert(dap.configurations.python, {
				type = "python",
				request = "launch",
				name = "FastAPI",
				module = "uvicorn",
				args = {
					"main:app",
					"--reload",
				},
				console = "integratedTerminal",
			})

			-- Configuração para Django
			table.insert(dap.configurations.python, {
				type = "python",
				request = "launch",
				name = "Django",
				program = "${workspaceFolder}/manage.py",
				args = {
					"runserver",
					"0.0.0.0:8000",
					"--noreload",
				},
				console = "integratedTerminal",
			})

			-- Configuração para Flask
			table.insert(dap.configurations.python, {
				type = "python",
				request = "launch",
				name = "Flask",
				module = "flask",
				env = {
					FLASK_APP = "app.py",
					FLASK_ENV = "development",
				},
				args = {
					"run",
					"--no-debugger",
				},
				console = "integratedTerminal",
			})
		end,
	},
}
