return {
	-- Navegação entre painéis do Tmux e janelas do Neovim
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		config = function()
			-- Configuração de navegação entre painéis no estilo Vim
			vim.g.tmux_navigator_no_mappings = 1
			-- Mapeamentos personalizados para navegação entre painéis
			vim.keymap.set("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { silent = true })
			vim.keymap.set("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { silent = true })
			vim.keymap.set("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { silent = true })
			vim.keymap.set("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { silent = true })
			-- Suporte para ressurreição de sessão
			vim.g.tmux_navigator_save_on_switch = 2
		end,
	},
	-- Integração de status line com o Tmux
	{
		"vimpostor/vim-tpipeline",
		lazy = false,
		config = function()
			vim.g.tpipeline_autoembed = 1
			vim.g.tpipeline_statusline = '%!v:lua.require("lualine").statusline()'
		end,
	},
}
