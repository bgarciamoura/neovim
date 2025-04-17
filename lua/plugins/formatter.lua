return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				-- Log para debugging
				log_level = vim.log.levels.DEBUG,

				formatters = {
					biome = {
						command = "biome",
						args = { "format", "--stdin-file-path", "$FILENAME" },
						stdin = true,
						require_cwd = true,
					},
				},
				formatters_by_ft = {
					javascript = { "biome" },
					typescript = { "biome" },
					javascriptreact = { "biome" },
					typescriptreact = { "biome" },
					json = { "fixjson" },
					css = { "biome", "css_beautify" },
					lua = {
						"stylua",
					},
					sh = {
						"shfmt",
					},
					kotlin = {
						"ktlint",
					},
					html = {
						"prettierd",
					},
					htmlangular = {
						"prettierd",
					},
				},
				format_on_save = {
					-- Aumentar o timeout para salvar
					timeout_ms = 3000,
					lsp_format = "fallback",
				},
			})
		end,

		vim.api.nvim_create_user_command("KtlintDebug", function()
			-- Executa o ktlint no arquivo atual e mostra a saída
			local file = vim.fn.expand("%:p")
			local cmd = "ktlint " .. vim.fn.shellescape(file)
			local output = vim.fn.system(cmd)

			-- Criar um buffer para exibir a saída
			local bufnr = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(output, "\n"))
			vim.api.nvim_command("split")
			vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), bufnr)
			vim.api.nvim_buf_set_option(bufnr, "filetype", "log")
			vim.api.nvim_buf_set_name(bufnr, "ktlint-debug")

			print("Ktlint output exibido em um novo buffer")
		end, {}),

		vim.api.nvim_create_user_command("KtlintVersion", function()
			-- Verifica a versão do ktlint
			local output = vim.fn.system("ktlint --version")
			print("Versão do ktlint: " .. output)
		end, {}),

		vim.api.nvim_create_user_command("KtlintFormat", function()
			-- Tenta formatar manualmente com ktlint
			local file = vim.fn.expand("%:p")
			local cmd = "ktlint --format " .. vim.fn.shellescape(file)
			local output = vim.fn.system(cmd)

			if vim.v.shell_error ~= 0 then
				print("Erro ao formatar: " .. output)
			else
				-- Recarrega o buffer após a formatação
				vim.cmd("e!")
				print("Formatação concluída com sucesso " .. vim.fn.shellescape(file))
			end
		end, {}),
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")

			lint.linters.biome = {
				cmd = "biome",
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

			-- Configurar ktlint para verificação de lint
			lint.linters.ktlint = {
				cmd = "ktlint",
				args = { "--log-level=error" }, -- Somente erros, não usar --reporter=json
				stdin = false,
				append_fname = true, -- Passar o nome do arquivo como argumento
				ignore_exitcode = true,
				parser = function(output, bufnr)
					-- Nova implementação simplificada do parser
					local diagnostics = {}
					for line in vim.gsplit(output, "\n") do
						if line and line ~= "" then
							-- Formato padrão do ktlint:
							-- file.kt:line:column: mensagem de erro (regra)
							local file, lnum, col, message = line:match("([^:]+):(%d+):(%d+):%s(.*)")
							if lnum and col and message then
								table.insert(diagnostics, {
									lnum = tonumber(lnum) - 1,
									col = tonumber(col) - 1,
									end_lnum = tonumber(lnum) - 1,
									end_col = tonumber(col),
									severity = vim.diagnostic.severity.WARN,
									message = message,
									source = "ktlint",
								})
							end
						end
					end
					return diagnostics
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
				prisma = { "prisma-language-server" },
				["docker-compose"] = { "hadolint" },
				["env"] = { "dotenv-linter" },
				["sh"] = { "shellcheck" },
				kotlin = { "ktlint" },
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
