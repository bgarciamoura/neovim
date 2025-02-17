return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local handle = io.popen("echo $USER")
    local username = handle:read("*a"):gsub("\n", "")
    handle:close()

    -- ASCII ART (Alternando entre banners aleatórios)
    local banners = {

      {
        "      ___           ___           ___           ___      ",
        "     /\\__\\         /\\  \\         /\\__\\         /\\  \\     ",
        "    /:/  /        /::\\  \\       /:/  /        /::\\  \\    ",
        "   /:/  /        /:/\\:\\  \\     /:/  /        /:/\\:\\  \\   ",
        "  /:/  /  ___   /:/  \\:\\  \\   /:/  /  ___   /:/  \\:\\  \\  ",
        " /:/__/  /\\__\\ /:/__/ \\:\\__\\ /:/__/  /\\__\\ /:/__/ \\:\\__\\ ",
        " \\:\\  \\ /:/  / \\:\\  \\ /:/  / \\:\\  \\ /:/  / \\:\\  \\ /:/  / ",
        "  \\:\\  /:/  /   \\:\\  /:/  /   \\:\\  /:/  /   \\:\\  /:/  /  ",
        "   \\:\\/:/  /     \\:\\/:/  /     \\:\\/:/  /     \\:\\/:/  /   ",
        "    \\::/  /       \\::/  /       \\::/  /       \\::/  /    ",
        "     \\/__/         \\/__/         \\/__/         \\/__/     ",
      },
      {
        "██████╗  ██████╗ ██████╗ ██████╗ ███████╗",
        "╚════██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝",
        " █████╔╝██║     ██║   ██║██║  ██║█████╗  ",
        "██╔═══╝ ██║     ██║   ██║██║  ██║██╔══╝  ",
        "███████╗╚██████╗╚██████╔╝██████╔╝███████╗",
        "╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝",
      },
      {
        " ▄████▄   ▒█████  ▓█████▄ ▓█████ ",
        "▒██▀ ▀█  ▒██▒  ██▒▒██▀ ██▌▓█   ▀ ",
        "▒▓█    ▄ ▒██░  ██▒░██   █▌▒███   ",
        "▒▓▓▄ ▄██▒▒██   ██░░▓█▄   ▌▒▓█  ▄ ",
        "▒ ▓███▀ ░░ ████▓▒░░▒████▓ ░▒████▒",
        "░ ░▒ ▒  ░░ ▒░▒░▒░  ▒▒▓  ▒ ░░ ▒░ ░",
        "  ░  ▒     ░ ▒ ▒░  ░ ▒  ▒  ░ ░  ░",
        "░        ░ ░ ░ ▒   ░ ░  ░    ░   ",
        "░ ░          ░ ░     ░       ░  ░",
        "░                  ░             ",
      },
      {
        "oooooooooo.    .oooooo.    ",
        "`888'   `Y8b  d8P'  `Y8b   ",
        " 888     888 888           ",
        " 888oooo888' 888           ",
        " 888    `88b 888     ooooo ",
        " 888    .88P `88.    .88'  ",
        "o888bood8P'   `Y8bood8P'   ",
      },
      {
        "██████╗  ██████╗ ",
        "██╔══██╗██╔════╝ ",
        "██████╔╝██║  ███╗",
        "██╔══██╗██║   ██║",
        "██████╔╝╚██████╔╝",
        "╚═════╝  ╚═════╝ ",
      },
    }

    -- Escolher um banner aleatório
    math.randomseed(os.time())
    dashboard.section.header.val = banners[math.random(#banners)]

    -- Botões de ação
    dashboard.section.buttons.val = {
      dashboard.button(
        "R",
        "  Restaurar Sessão",
        "[[<cmd>lua require('persistence').load({ last = true })<CR>]]"
      ),
      dashboard.button("e", "📄 Novo Arquivo", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "🔍 Buscar Arquivo", ":Telescope find_files<CR>"),
      dashboard.button("r", "📂 Arquivos Recentes", ":Telescope oldfiles<CR>"),
      dashboard.button("n", "📁 Abrir Neo-tree", ":Neotree toggle<CR>"),
      dashboard.button("s", "⚙️  Configurações", ":e $MYVIMRC<CR>"),
      dashboard.button("q", "🚪 Sair", ":qa<CR>"),
    }

    -- Função para obter o tempo de inicialização do Neovim
    local function get_startuptime()
      local stats = require("lazy").stats()
      return string.format("🚀 Carregados %d plugins em %.2fms", stats.loaded, stats.startuptime)
    end

    -- Seção com métricas do Neovim
    dashboard.section.footer.val = {
      "",
      "Olá, " .. username .. "! 👋",
      get_startuptime(),
      "⌨️  Feito com Neovim e ❤️",
    }

    -- Aplicar tema e configuração ao Alpha
    alpha.setup(dashboard.config)
  end,
}
