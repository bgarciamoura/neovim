-- Load core settings (options, autocmds) and set leader keys before lazy
require("core")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins.ui" },
		{ import = "plugins.editor" },
		{ import = "plugins.lsp" },
		{ import = "plugins.tools" },
		{ import = "plugins.git" },
		{ import = "plugins.debug" },
		{ import = "plugins.test" },
		{ import = "plugins.notebook" },
		{ import = "plugins.session" },
		{ import = "plugins.tasks" },
	},

	defaults = {
		lazy = true,
	},

	install = {
		colorscheme = { "cyberdream", "habamax" },
	},

	checker = {
		enabled = false,
	},

	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- Load keymaps after plugins are set up
-- (file will be created in a later task)
local ok_keymaps, err_keymaps = pcall(require, "config.keymaps")
if not ok_keymaps and not err_keymaps:find("not found") then
	vim.notify("Error loading config.keymaps: " .. err_keymaps, vim.log.levels.ERROR)
end

-- Load project detection
-- (file will be created in a later task)
local ok_project, err_project = pcall(require, "config.project")
if not ok_project and not err_project:find("not found") then
	vim.notify("Error loading config.project: " .. err_project, vim.log.levels.ERROR)
end
