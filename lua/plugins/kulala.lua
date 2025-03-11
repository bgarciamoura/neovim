return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	config = function()
		require("kulala").setup({
			global_keymaps = true, -- Isso ativa os atalhos padrão do Kulala
		})
	end,
}
