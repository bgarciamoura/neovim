-- Importar o wrapper de neoconf
local neoconf_wrapper = require("core.neoconf-wrapper")

-- Configurar o LSP após garantir que neoconf está inicializado
neoconf_wrapper.setup_lspconfig(function()
	local lspconfig = require("lspconfig")

	-- Função para anexar configurações extras ao LSP
	local on_attach = function(client, bufnr)
		local opts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Ir para definição
		-- voltar da definição
		vim.keymap.set("n", "<C-o>", function()
			vim.api.nvim_command("normal! <C-o>")
		end, opts)

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Mostrar documentação
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Renomear símbolo
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Sugestão de correções
	end

	-- Configurar servidores
	local servers = {
		"ts_ls",
		"html",
		"cssls",
		"jsonls",
		"lua_ls",
		"angularls",
		"dockerls",
		"prismals",
		"nxls",
		"somesass_ls",
		"biome",
		"bashls",
	}

	for _, server in ipairs(servers) do
		if lspconfig[server] then
			lspconfig[server].setup({
				on_attach = on_attach,
			})
		else
			print("AVISO: Servidor LSP não encontrado: " .. server)
		end
	end

	local default_config = {
		virtual_lines = false,
		virtual_text = {
			prefix = "●",
			spacing = 2,
		},
	}

	vim.diagnostic.config(default_config)

	vim.keymap.set("n", "<leader>dI", function()
		if vim.diagnostic.config().virtual_lines == true then
			vim.diagnostic.config(default_config)
		else
			vim.diagnostic.config({ virtual_lines = true })
			vim.diagnostic.config({
				virtual_text = false,
			})
		end
	end, { desc = "Toggle showing all diagnostics" })
end)
