return {
	-- Inline markdown rendering inside Neovim buffers
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function(_, opts)
			-- Fundo suave para blocos de código (mais próximo do bg normal #101825)
			vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#141c2a" })
			vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "#141c2a" })
			vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { bg = "#141c2a" })

			require("render-markdown").setup(opts)
		end,
		opts = {
			-- Renderiza apenas no modo Normal (insert mostra raw)
			render_modes = { "n", "c" },
			-- Não revela raw na linha do cursor no modo Normal
			anti_conceal = {
				enabled = false,
			},
			heading = {
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			},
			code = {
				enabled = true,
				sign = true,
				style = "full",
			},
			bullet = {
				icons = { "●", "○", "◆", "◇" },
			},
			checkbox = {
				unchecked = { icon = "  " },
				checked = { icon = "  " },
			},
		},
	},

	-- Browser-based markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
