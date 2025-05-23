return {
	"DaikyXendo/nvim-material-icon",
	config = function()
		require("nvim-web-devicons").setup({
			default = true,
			strict = true,
			-- your personnal icons can go here (to override)
			--   -- you can specify color or cterm_color instead of specifying both of them
			--     -- DevIcon will be appended to `name`
			override = {
				zsh = {
					icon = "",
					color = "#428850",
					cterm_color = "65",
					name = "Zsh",
				},
			},
			-- globally enable different highlight colors per icon (default to true)
			-- if set to false all icons will have the default icon's color
			color_icons = true,
			-- globally enable default icons (default to false)
			-- will get overriden by `get_icons` option
		})
	end,
}
