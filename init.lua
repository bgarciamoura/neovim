-- Iniciar medição de tempo (coloque isso o mais no topo possível)
vim.g.start_time = vim.loop.hrtime()

-- Carrega o módulo de diagnóstico de performance
local diagnostic_ok, diagnostic = pcall(require, "core.diagnostic")
if diagnostic_ok then
	diagnostic.setup()
end

require("core.options")
require("core.autocommands")
require("config.lazy")
require("config.lspconfig")

-- Theme
require("themes.morta")

-- vim.cmd.colo:rscheme("catppuccin")
