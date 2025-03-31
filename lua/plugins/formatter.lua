return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					javascript = { "biome", "prettier" },
					typescript = { "biome", "prettier" },
					json = { "fixjson" },
					css = { "biome", "css_beautify" },
					lua = {
						"stylua",
					},
					sh = {
						"shfmt",
					},
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters.biome = {
				cmd = "biome", -- O comando a ser executado
				stdin = true,
				args = { "check", "--json" },
				ignore_exitcode = true,
				parser = function(output)
					local messages = {}
					local ok, data = pcall(vim.fn.json_decode, output)
					if not ok or not data then
						return messages
					end

					for _, diagnostic in ipairs(data.diagnostics or {}) do
						table.insert(messages, {
							lnum = diagnostic.range.start.line,
							col = diagnostic.range.start.character,
							end_lnum = diagnostic.range["end"].line,
							end_col = diagnostic.range["end"].character,
							severity = vim.diagnostic.severity.WARN,
							message = diagnostic.message,
							source = "biome",
						})
					end
					return messages
				end,
			}

			lint.linters_by_ft = {
				javascript = { "biome" },
				javascriptreact = { "biome" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
				html = { "htmlhint" },
				css = { "stylelint" },
				scss = { "stylelint" },
				json = { "jsonlint" },
				markdown = { "markdownlint" },
				dockerfile = { "hadolint" },
				yaml = { "yamllint" },
				xml = { "xmllint" },
				prisma = { "prisma-language-server" }, -- Requer o Prisma CLI
				["docker-compose"] = { "hadolint" },
				["env"] = { "dotenv-linter" }, -- Para arquivos .env
				["sh"] = { "shellcheck" },
			}

			-- Lint automático ao salvar ou abrir um arquivo
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
