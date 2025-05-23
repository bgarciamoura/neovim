local vim = vim

return {
	-- Plugin principal de autocomplete
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Suporte ao LSP
			"hrsh7th/cmp-buffer", -- Sugestões do buffer atual
			"hrsh7th/cmp-path", -- Sugestões de arquivos
			"L3MON4D3/LuaSnip", -- Suporte a snippets
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim", -- Ícones no autocomplete
			"rafamadriz/friendly-snippets", -- Snippets
			"dsznajder/vscode-react-javascript-snippets", -- Snippets para React/TypeScript
			"zbirenbaum/copilot-cmp", -- Integração Copilot com cmp (versão Lua)
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			require("luasnip.loaders.from_vscode").lazy_load()

			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node

			-- Adicionar snippets específicos para NextJS
			ls.add_snippets("typescriptreact", {
				-- getStaticProps
				s("ngsp", {
					t("export const getStaticProps: GetStaticProps = async (context) => {"),
					t({ "", "  " }),
					i(1, "// Fetch data"),
					t({ "", "  return {" }),
					t({ "", "    props: {" }),
					i(2, "// Props"),
					t({ "", "    }," }),
					t({ "", "  }" }),
					t({ "", "}" }),
				}),

				-- getStaticPaths
				s("ngspath", {
					t("export const getStaticPaths: GetStaticPaths = async () => {"),
					t({ "", "  " }),
					i(1, "// Fetch data for paths"),
					t({ "", "  const paths = " }),
					i(2, "[]"),
					t({ "", "  return {" }),
					t({ "", "    paths," }),
					t({ "", "    fallback: " }),
					i(3, "false"),
					t({ "", "  }" }),
					t({ "", "}" }),
				}),

				-- API route
				s("napi", {
					t("export default async function handler(req, res) {"),
					t({ "", "  const { method } = req" }),
					t({ "", "" }),
					t({ "", "  switch (method) {" }),
					t({ "", "    case 'GET':" }),
					t({ "", "      " }),
					i(1, "// Handle GET request"),
					t({ "", "      return res.status(200).json({ message: 'Success' })" }),
					t({ "", "    default:" }),
					t({ "", "      res.setHeader('Allow', ['GET'])" }),
					t({ "", "      return res.status(405).json({ message: `Method ${method} Not Allowed` })" }),
					t({ "", "  }" }),
					t({ "", "}" }),
				}),
			})

			ls.add_snippets("kotlin", {
				s("sbcontroller", {
					t("@RestController"),
					t({ "", '@RequestMapping("/api/' }),
					i(1, "resource"),
					t('")'),
					t({ "", "class " }),
					i(2, "NameController"),
					t("("),
					t({ "", "    private val " }),
					i(3, "nameService"),
					t(": "),
					i(4, "NameService"),
					t({ "", ") {", "" }),
					t({ "", "    @GetMapping" }),
					t({ "", "    fun getAll(): List<" }),
					i(5, "Model"),
					t("> {"),
					t({ "", "        return " }),
					i(3),
					t("."),
					i(6, "findAll()"),
					t({ "", "    }" }),
					t({ "", "}" }),
				}),

				s("sbservice", {
					t("@Service"),
					t({ "", "class " }),
					i(1, "NameService"),
					t("("),
					t({ "", "    private val " }),
					i(2, "repository"),
					t(": "),
					i(3, "NameRepository"),
					t({ "", ") {", "" }),
					t({ "", "    fun findAll(): List<" }),
					i(4, "Model"),
					t("> {"),
					t({ "", "        return " }),
					i(2),
					t(".findAll()"),
					t({ "", "    }" }),
					t({ "", "}" }),
				}),

				s("sbrepo", {
					t("@Repository"),
					t({ "", "interface " }),
					i(1, "NameRepository"),
					t(" : JpaRepository<"),
					i(2, "Model"),
					t(", "),
					i(3, "Long"),
					t("> {"),
					t({ "", "}" }),
				}),

				s("sbentity", {
					t("@Entity"),
					t({ "", "data class " }),
					i(1, "Name"),
					t("("),
					t({ "", "    @Id" }),
					t({ "", "    @GeneratedValue(strategy = GenerationType.IDENTITY)" }),
					t({ "", "    val id: Long? = null," }),
					t({ "", "    " }),
					i(2, "val name: String"),
					t({ "", ")" }),
				}),

				s("sbreqdto", {
					t("data class "),
					i(1, "NameRequest"),
					t("("),
					t({ "", "    " }),
					i(2, "val name: String"),
					t({ "", ")" }),
				}),

				s("sbresdto", {
					t("data class "),
					i(1, "NameResponse"),
					t("("),
					t({ "", "    val id: Long," }),
					t({ "", "    " }),
					i(2, "val name: String"),
					t({ "", ")" }),
				}),

				s("ktextfun", {
					t("fun "),
					i(1, "Class"),
					t("."),
					i(2, "functionName"),
					t("(): "),
					i(3, "ReturnType"),
					t(" {"),
					t({ "", "    " }),
					i(0),
					t({ "", "}" }),
				}),
			})

			cmp.setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol", -- show only symbol annotations
						maxwidth = {
							menu = 50, -- leading text (labelDetails)
							abbr = 50, -- actual suggestion item
						},
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default
						before = function(entry, vim_item)
							return vim_item
						end,
					}),
				},
				mapping = {
					["<C-n>"] = cmp.mapping.select_next_item(), -- Próxima sugestão
					["<C-p>"] = cmp.mapping.select_prev_item(), -- Sugestão anterior
					["<Down>"] = cmp.mapping.select_next_item(), -- Próxima sugestão (seta para baixo)
					["<Up>"] = cmp.mapping.select_prev_item(), -- Sugestão anterior (seta para cima)
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirmação do autocomplete
					["<ESC>"] = cmp.mapping.close(), -- Fecha o autocomplete
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				},
				sources = cmp.config.sources({
					{ name = "copilot" }, -- Sugestões do Copilot (adicionado)
					{ name = "nvim_lsp" }, -- Sugestões do LSP
					{ name = "buffer" }, -- Sugestões do buffer
					{ name = "path" }, -- Sugestões de arquivos
					{ name = "luasnip" }, -- Snippets
					{ name = "render-markdown" },
				}),
			})
		end,
	},

	-- Configuração do Copilot.lua
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			-- Carregar o módulo de sugestões para verificação da visibilidade
			local copilot_suggestion = require("copilot.suggestion")

			-- Configurar o atalho Tab customizado
			vim.keymap.set("i", "<Tab>", function()
				if copilot_suggestion.is_visible() then
					copilot_suggestion.accept()
				else
					-- Enviar um Tab normal quando não há sugestões
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end, { desc = "Accept copilot suggestion or indent" })

			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = true,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom",
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true, -- Crucial para sugestões inline automáticas
					debounce = 75,
					keymap = {
						-- Removido o Tab como tecla de aceitação, será tratado pelo keymap personalizado acima
						accept = false,
						accept_word = "<M-w>", -- Aceitar apenas uma palavra
						accept_line = "<M-l>", -- Aceitar a linha inteira
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				-- Deixa o Copilot mais agressivo nas sugestões
				copilot_node_command = "node",
				server_opts_overrides = {
					inlineSuggestCount = 3, -- Mostrar mais sugestões
				},
			})
		end,
	},

	-- Integração do Copilot com o nvim-cmp
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup({
				event = { "InsertEnter", "LspAttach" },
				fix_pairs = true,
				formatters = {
					label = require("copilot_cmp.format").format_label_text,
					insert_text = require("copilot_cmp.format").format_insert_text,
					preview = require("copilot_cmp.format").deindent,
				},
				-- Usar apenas quando você explicitamente aciona o nvim-cmp
				-- (não mostra Copilot automaticamente no menu pop-up)
				sources = {
					{ name = "copilot", group_index = 2, priority = 100 },
				},
			})
		end,
	},

	-- Desativar explicitamente a versão oficial para evitar conflitos
	{
		"github/copilot.vim",
		enabled = false,
	},

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
