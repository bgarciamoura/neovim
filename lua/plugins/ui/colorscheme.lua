return {
	-- Alternative: Catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			integrations = {
				alpha = true,
				blink_cmp = {
					enabled = true,
					style = "bordered",
				},
				dap = true,
				dap_ui = true,
				fidget = true,
				gitsigns = {
					enabled = true,
					transparent = false,
				},
				mason = true,
				neotree = true,
				neotest = true,
				noice = true,
				notify = true,
				telescope = {
					enabled = true,
				},
				treesitter = true,
				which_key = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
						ok = { "undercurl" },
					},
					inlay_hints = {
						background = true,
					},
				},
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
		end,
	},

	-- Alternative: Tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			style = "storm",
			transparent = false,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				sidebars = "dark",
				floats = "dark",
			},
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
		end,
	},

	-- Alternative: Rose Pine
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		opts = {
			variant = "main",
			dark_variant = "main",
			dim_inactive_windows = false,
			extend_background_behind_borders = true,
			styles = {
				bold = true,
				italic = true,
				transparency = false,
			},
		},
	},

	-- Cyberdream (alternative)
	{
		"scottmckendry/cyberdream.nvim",
		lazy = true,
		opts = {
			transparent = false,
			italic_comments = true,
			hide_fillchars = false,
			terminal_colors = true,
			cache = true,
		},
		config = function(_, opts)
			require("cyberdream").setup(opts)
		end,
	},

	-- Vague (alternative)
	{
		"vague2k/vague.nvim",
		lazy = true,
		config = function()
			require("vague").setup({
				transparent = false,
				style = {
					comments = "italic",
					conditionals = "none",
					functions = "none",
					keywords = "none",
					headings = "bold",
					operators = "none",
					keyword_return = "none",
					strings = "italic",
					variables = "none",
				},
			})
		end,
	},

	-- Primary colorscheme: Oasis
	{
		"uhs-robert/oasis.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("oasis").setup({
				style = "lagoon",
				themed_syntax = true,
				styles = {
					bold = true,
					italic = true,
					underline = true,
					undercurl = true,
					strikethrough = true,
				},
				transparent = false,
				terminal_colors = true,
			})
			vim.cmd.colorscheme("oasis")
		end,
	},
}
