# Neovim Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a full IDE-like Neovim 0.12.0 configuration from scratch — modular by domain, lazy-loaded, with project-aware tooling and centralized keymaps.

**Architecture:** Modular by domain under `lua/plugins/` with subdirectories per concern (editor, ui, lsp, tools, etc.). All keymaps centralized in `lua/config/keymaps.lua` with which-key. Project detection in `lua/config/project.lua` activates tools conditionally. Plugin manager: lazy.nvim with aggressive lazy loading.

**Tech Stack:** Neovim 0.12.0, Lua, lazy.nvim, native LSP, mason.nvim, blink.cmp, Telescope, Neo-tree, toggleterm, nvim-dap, neotest, molten.nvim

**Spec:** `docs/superpowers/specs/2026-03-31-neovim-config-design.md`

---

## File Structure

```
init.lua                              -- entry point
lua/
  core/
    init.lua                          -- loads options + autocmds
    options.lua                       -- vim.opt settings
    autocmds.lua                      -- global autocommands
  config/
    keymaps.lua                       -- ALL keymaps (core + plugins)
    project.lua                       -- project detection + conditional activation
  plugins/
    ui/
      colorscheme.lua                 -- catppuccin + tokyonight + rose-pine
      icons.lua                       -- nvim-web-devicons
      statusline.lua                  -- lualine.nvim
      dashboard.lua                   -- alpha-nvim
      noice.lua                       -- noice.nvim
      fidget.lua                      -- fidget.nvim
    editor/
      treesitter.lua                  -- nvim-treesitter + textobjects
      autopairs.lua                   -- nvim-autopairs
      surround.lua                    -- nvim-surround
      comment.lua                     -- Comment.nvim + ts-context-commentstring
      todo.lua                        -- todo-comments.nvim
      colorizer.lua                   -- nvim-colorizer
    lsp/
      lsp.lua                         -- native LSP config
      mason.lua                       -- mason.nvim
      conform.lua                     -- conform.nvim
      lint.lua                        -- nvim-lint
      blink.lua                       -- blink.cmp
    tools/
      telescope.lua                   -- telescope.nvim + extensions
      neo-tree.lua                    -- neo-tree.nvim
      toggleterm.lua                  -- toggleterm.nvim
      bruno.lua                       -- bruno.nvim
      docker.lua                      -- docker.nvim
      markdown.lua                    -- render-markdown.nvim + markdown-preview.nvim
      arrow.lua                       -- arrow.nvim
    git/
      gitsigns.lua                    -- gitsigns.nvim
    debug/
      dap.lua                         -- nvim-dap + dap-ui + virtual-text
    test/
      neotest.lua                     -- neotest + adapters
    notebook/
      molten.lua                      -- molten.nvim + jupytext
    session/
      auto-session.lua                -- auto-session
    tasks/
      overseer.lua                    -- overseer.nvim
```

---

## Task 1: Core Bootstrap — init.lua, options, autocmds, lazy.nvim

**Files:**
- Create: `init.lua`
- Create: `lua/core/init.lua`
- Create: `lua/core/options.lua`
- Create: `lua/core/autocmds.lua`

- [ ] **Step 1: Create `lua/core/options.lua`**

```lua
local opt = vim.opt

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.showmode = false -- lualine shows mode

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Scroll
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Clipboard
opt.clipboard = "unnamedplus"

-- Undo
opt.undofile = true
opt.undolevels = 10000

-- Misc
opt.updatetime = 250
opt.timeoutlen = 300 -- for which-key
opt.confirm = true
opt.mouse = "a"
opt.fillchars = { eob = " " }

-- Disable netrw (neo-tree replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
```

- [ ] **Step 2: Create `lua/core/autocmds.lua`**

```lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Restore cursor position
autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Close certain filetypes with q
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = { "help", "qf", "notify", "checkhealth", "man", "lspinfo" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
```

- [ ] **Step 3: Create `lua/core/init.lua`**

```lua
require("core.options")
require("core.autocmds")
```

- [ ] **Step 4: Create `init.lua` with lazy.nvim bootstrap**

```lua
require("core")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

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
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true, notify = false },
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
require("config.keymaps")
```

- [ ] **Step 5: Verify bootstrap works**

Run: `nvim --headless -c 'echo "OK"' -c 'qa'`
Expected: lazy.nvim clones itself, no errors. Then open `nvim` interactively — should see empty screen with no errors.

- [ ] **Step 6: Commit**

```bash
git add init.lua lua/core/
git commit -m "feat: core bootstrap — options, autocmds, lazy.nvim"
```

---

## Task 2: UI Foundation — Icons + Colorscheme

**Files:**
- Create: `lua/plugins/ui/icons.lua`
- Create: `lua/plugins/ui/colorscheme.lua`

- [ ] **Step 1: Create `lua/plugins/ui/icons.lua`**

```lua
return {
  "nvim-tree/nvim-web-devicons",
  lazy = false,
  opts = {
    color_icons = true,
    default = true,
    strict = true,
  },
}
```

- [ ] **Step 2: Create `lua/plugins/ui/colorscheme.lua`**

Consult latest docs for catppuccin, tokyonight, and rose-pine via context7 before writing. The config below is a starting point:

```lua
return {
  -- Catppuccin (primary)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        alpha = true,
        blink_cmp = true,
        gitsigns = true,
        mason = true,
        neo_tree = true,
        neotest = true,
        noice = true,
        notify = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        fidget = true,
        dap = true,
        dap_ui = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Tokyonight (alternative)
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "storm" },
  },

  -- Rose Pine (alternative)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = { variant = "main" },
  },
}
```

- [ ] **Step 3: Verify theme loads**

Run: `nvim`
Expected: Catppuccin Mocha theme applied. Verify with `:colorscheme` — should show `catppuccin`. Test switching: `:colorscheme tokyonight` and `:colorscheme rose-pine`.

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/ui/icons.lua lua/plugins/ui/colorscheme.lua
git commit -m "feat(ui): add colorschemes and devicons"
```

---

## Task 3: Statusline — lualine.nvim

**Files:**
- Create: `lua/plugins/ui/statusline.lua`

- [ ] **Step 1: Create `lua/plugins/ui/statusline.lua`**

Consult latest lualine docs via context7 for current API.

```lua
return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "catppuccin",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "alpha" },
      },
    },
    sections = {
      lualine_a = {
        { "mode", icon = "" },
      },
      lualine_b = {
        { "branch", icon = "" },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
        },
      },
      lualine_c = {
        { "filename", path = 1, symbols = { modified = " ", readonly = " " } },
        {
          "diagnostics",
          symbols = {
            error = " ",
            warn = " ",
            hint = " ",
            info = " ",
          },
        },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return ""
            end
            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            return " " .. table.concat(names, ", ")
          end,
        },
        { "encoding" },
        { "filetype", icon_only = false },
      },
      lualine_y = { "progress" },
      lualine_z = {
        { "location", icon = "" },
      },
    },
  },
}
```

- [ ] **Step 2: Verify statusline**

Run: `nvim lua/core/options.lua`
Expected: Statusline at bottom shows mode icon, branch, filename, filetype, position. No `-- INSERT --` text (showmode is off).

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/ui/statusline.lua
git commit -m "feat(ui): add lualine statusline"
```

---

## Task 4: Dashboard — alpha-nvim

**Files:**
- Create: `lua/plugins/ui/dashboard.lua`

- [ ] **Step 1: Create `lua/plugins/ui/dashboard.lua`**

Consult latest alpha-nvim docs via context7.

```lua
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                    ]],
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      [[                                                    ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find File", "<cmd>Telescope find_files<cr>"),
      dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("g", "  Find Word", "<cmd>Telescope live_grep<cr>"),
      dashboard.button("s", "  Restore Session", "<cmd>SessionRestore<cr>"),
      dashboard.button("c", "  Config", "<cmd>e $MYVIMRC<cr>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
    }

    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      return "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. string.format("%.2f", stats.startuptime) .. "ms"
    end

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    alpha.setup(dashboard.opts)
  end,
}
```

- [ ] **Step 2: Verify dashboard**

Run: `nvim` (with no file argument)
Expected: ASCII art header, action buttons with icons, footer with stats. Press `f` to trigger find file (will error if Telescope not yet installed — that's ok for now).

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/ui/dashboard.lua
git commit -m "feat(ui): add alpha-nvim dashboard with ASCII art"
```

---

## Task 5: Notifications — noice.nvim + fidget.nvim

**Files:**
- Create: `lua/plugins/ui/noice.lua`
- Create: `lua/plugins/ui/fidget.lua`

- [ ] **Step 1: Create `lua/plugins/ui/noice.lua`**

Consult latest noice.nvim docs via context7.

```lua
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
    messages = {
      enabled = true,
      view = "notify",
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      progress = {
        enabled = false, -- fidget handles this
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
}
```

- [ ] **Step 2: Create `lua/plugins/ui/fidget.lua`**

```lua
return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    notification = {
      window = {
        winblend = 0,
      },
    },
  },
}
```

- [ ] **Step 3: Verify notifications**

Run: `nvim` then type `:` — cmdline should appear as a floating popup (noice). Type `:Lazy` — messages should show as notifications.

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/ui/noice.lua lua/plugins/ui/fidget.lua
git commit -m "feat(ui): add noice.nvim notifications and fidget LSP progress"
```

---

## Task 6: Treesitter + Textobjects

**Files:**
- Create: `lua/plugins/editor/treesitter.lua`

- [ ] **Step 1: Create `lua/plugins/editor/treesitter.lua`**

Consult latest nvim-treesitter and nvim-treesitter-textobjects docs via context7.

```lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "typescript",
        "tsx",
        "javascript",
        "python",
        "lua",
        "dart",
        "json",
        "yaml",
        "toml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "regex",
        "vim",
        "vimdoc",
        "dockerfile",
        "gitignore",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "outer function" },
            ["if"] = { query = "@function.inner", desc = "inner function" },
            ["ac"] = { query = "@class.outer", desc = "outer class" },
            ["ic"] = { query = "@class.inner", desc = "inner class" },
            ["aa"] = { query = "@parameter.outer", desc = "outer parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "inner parameter" },
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Prev function start" },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Prev function end" },
            ["[C"] = { query = "@class.outer", desc = "Prev class end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = { query = "@parameter.inner", desc = "Swap next parameter" },
          },
          swap_previous = {
            ["<leader>A"] = { query = "@parameter.inner", desc = "Swap prev parameter" },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
```

- [ ] **Step 2: Verify treesitter**

Run: `nvim lua/core/options.lua`
Expected: Syntax highlighting via treesitter (not regex). Run `:TSInstallInfo` — parsers should be installing. Test textobjects: place cursor on a function, type `vaf` — should select entire function.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/editor/treesitter.lua
git commit -m "feat(editor): add treesitter with textobjects"
```

---

## Task 7: Editor Essentials — autopairs, surround, comment, todo, colorizer

**Files:**
- Create: `lua/plugins/editor/autopairs.lua`
- Create: `lua/plugins/editor/surround.lua`
- Create: `lua/plugins/editor/comment.lua`
- Create: `lua/plugins/editor/todo.lua`
- Create: `lua/plugins/editor/colorizer.lua`

- [ ] **Step 1: Create `lua/plugins/editor/autopairs.lua`**

Consult latest nvim-autopairs docs via context7.

```lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
      typescript = { "template_string" },
    },
    fast_wrap = {
      map = "<M-e>",
    },
  },
}
```

- [ ] **Step 2: Create `lua/plugins/editor/surround.lua`**

```lua
return {
  "kylechui/nvim-surround",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
}
```

- [ ] **Step 3: Create `lua/plugins/editor/comment.lua`**

Consult latest Comment.nvim and ts-context-commentstring docs via context7.

```lua
return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlvworte/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "JoosepAlvworte/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
}
```

- [ ] **Step 4: Create `lua/plugins/editor/todo.lua`**

```lua
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = true,
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    },
  },
}
```

- [ ] **Step 5: Create `lua/plugins/editor/colorizer.lua`**

```lua
return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    "css",
    "scss",
    "html",
    "javascript",
    "typescript",
    "typescriptreact",
    "javascriptreact",
    "lua",
    "*",
  },
}
```

- [ ] **Step 6: Verify all editor plugins**

Run: `nvim lua/core/options.lua`
- Type `(` — should auto-close to `()`
- Select word, type `ysiw"` — should wrap in quotes
- Type `gcc` on a line — should toggle comment
- Write `-- TODO: test` — should highlight with icon
- Write `color = "#ff0000"` in a CSS file — should show red preview

- [ ] **Step 7: Commit**

```bash
git add lua/plugins/editor/
git commit -m "feat(editor): add autopairs, surround, comment, todo, colorizer"
```

---

## Task 8: Telescope + Extensions

**Files:**
- Create: `lua/plugins/tools/telescope.lua`

- [ ] **Step 1: Create `lua/plugins/tools/telescope.lua`**

Consult latest telescope.nvim docs via context7. Verify telescope-fzf-native build command for Windows.

```lua
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "__pycache__",
          ".venv",
          "%.lock",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
  end,
}
```

- [ ] **Step 2: Verify Telescope**

Run: `nvim`, then `:Telescope find_files`
Expected: Fuzzy finder opens with file list, icons per file. Search works with fuzzy matching. `<Esc>` closes.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/tools/telescope.lua
git commit -m "feat(tools): add telescope with fzf-native and ui-select"
```

---

## Task 9: Neo-tree

**Files:**
- Create: `lua/plugins/tools/neo-tree.lua`

- [ ] **Step 1: Create `lua/plugins/tools/neo-tree.lua`**

Consult latest neo-tree.nvim docs via context7.

```lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          "node_modules",
          "__pycache__",
          ".venv",
          ".git",
        },
      },
    },
    window = {
      position = "left",
      width = 35,
      mappings = {
        ["<space>"] = "none", -- don't conflict with leader
      },
    },
    default_component_configs = {
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
      },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem", display_name = " 󰉓 Files " },
        { source = "buffers", display_name = " 󰈚 Buffers " },
        { source = "git_status", display_name = " 󰊢 Git " },
      },
    },
  },
}
```

- [ ] **Step 2: Verify Neo-tree**

Run: `nvim`, then `:Neotree toggle`
Expected: Sidebar opens on left with colorful icons, git status per file, source tabs at top (Files/Buffers/Git). `<space>` doesn't trigger leader conflicts.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/tools/neo-tree.lua
git commit -m "feat(tools): add neo-tree with colorful icons and git status"
```

---

## Task 10: LSP + Mason

**Files:**
- Create: `lua/plugins/lsp/lsp.lua`
- Create: `lua/plugins/lsp/mason.lua`

- [ ] **Step 1: Create `lua/plugins/lsp/mason.lua`**

Consult latest mason.nvim docs via context7.

```lua
return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  opts = {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    ensure_installed = {
      -- LSP servers
      "typescript-language-server",
      "pyright",
      "lua-language-server",
      "json-lsp",
      "html-lsp",
      "css-lsp",
      "yaml-language-server",
      "taplo",
      "marksman",
      "dockerfile-language-server",
      "docker-compose-language-service",
      -- Formatters
      "prettierd",
      "black",
      "stylua",
      -- Linters
      "eslint_d",
      "ruff",
      "luacheck",
      "markdownlint",
      "hadolint",
      -- DAP
      "js-debug-adapter",
      "debugpy",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    -- Auto-install ensure_installed packages
    local mr = require("mason-registry")
    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}
```

- [ ] **Step 2: Create `lua/plugins/lsp/lsp.lua`**

This uses Neovim 0.12 native LSP API. Consult `:help vim.lsp.config` and `:help vim.lsp.enable` for the exact API.

```lua
return {
  {
    "mason-org/mason.nvim",
    -- just a dependency reference, config in mason.lua
  },
  {
    -- SchemaStore for JSON/YAML schemas
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    -- Flutter tools (includes dartls + DAP)
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      lsp = {
        color = {
          enabled = true,
          virtual_text = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
      widget_guides = { enabled = true },
    },
  },
  {
    -- Virtual plugin to configure native LSP after mason installs servers
    dir = vim.fn.stdpath("config"),
    name = "lsp-config",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      -- Diagnostic config
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- LSP hover/signature borders
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- Server configurations
      vim.lsp.config("ts_ls", {
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      -- Simple servers (no extra config needed)
      vim.lsp.config("html", {})
      vim.lsp.config("cssls", {})
      vim.lsp.config("taplo", {})
      vim.lsp.config("marksman", {})
      vim.lsp.config("dockerls", {})
      vim.lsp.config("docker_compose_language_service", {})

      -- Enable all configured servers
      vim.lsp.enable({
        "ts_ls",
        "pyright",
        "lua_ls",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
        "taplo",
        "marksman",
        "dockerls",
        "docker_compose_language_service",
      })
    end,
  },
}
```

- [ ] **Step 3: Verify LSP**

Run: `nvim lua/core/options.lua`
Expected: `lua_ls` attaches automatically. Check with `:checkhealth lsp`. Hover over `vim.opt` — should show documentation popup with rounded border. Diagnostics icons should appear in the sign column.

Run: `:Mason` — should show UI with installed/pending tools.

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/lsp/lsp.lua lua/plugins/lsp/mason.lua
git commit -m "feat(lsp): add native LSP config with mason for 11 servers"
```

---

## Task 11: Completion — blink.cmp

**Files:**
- Create: `lua/plugins/lsp/blink.lua`

- [ ] **Step 1: Create `lua/plugins/lsp/blink.lua`**

Consult latest blink.cmp docs via context7 — API changes frequently.

```lua
return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  version = "*",
  opts = {
    keymap = {
      preset = "default",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind" },
          },
        },
      },
      ghost_text = { enabled = false },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
```

- [ ] **Step 2: Wire autopairs with blink.cmp**

Update `lua/plugins/editor/autopairs.lua` to integrate with blink if the API supports it. Check blink.cmp docs for autopairs integration. If blink.cmp has `auto_brackets` (already enabled above), nvim-autopairs integration may not be needed — verify and adjust.

- [ ] **Step 3: Verify completion**

Run: `nvim lua/core/options.lua`, enter insert mode, type `vim.` — completion popup should appear with icons, LSP suggestions, rounded borders. Tab/S-Tab to navigate, Enter to accept. Documentation panel should show on the side.

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/lsp/blink.lua
git commit -m "feat(lsp): add blink.cmp completion with snippets"
```

---

## Task 12: Formatting + Linting — conform.nvim + nvim-lint

**Files:**
- Create: `lua/plugins/lsp/conform.lua`
- Create: `lua/plugins/lsp/lint.lua`

- [ ] **Step 1: Create `lua/plugins/lsp/conform.lua`**

Consult latest conform.nvim docs via context7.

```lua
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      markdown = { "prettierd" },
      python = { "black" },
      lua = { "stylua" },
      dart = { "dart_format" },
    },
    format_on_save = {
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
  },
}
```

- [ ] **Step 2: Create `lua/plugins/lsp/lint.lua`**

Consult latest nvim-lint docs via context7.

```lua
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      python = { "ruff" },
      lua = { "luacheck" },
      markdown = { "markdownlint" },
      dockerfile = { "hadolint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
      group = lint_augroup,
      callback = function()
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })
  end,
}
```

- [ ] **Step 3: Verify formatting and linting**

Run: `nvim lua/core/options.lua`, save with unformatted code — stylua should format on save.
Run: `:ConformInfo` — should show active formatters for current filetype.

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/lsp/conform.lua lua/plugins/lsp/lint.lua
git commit -m "feat(lsp): add conform.nvim formatting and nvim-lint linting"
```

---

## Task 13: Git — gitsigns.nvim

**Files:**
- Create: `lua/plugins/git/gitsigns.lua`

- [ ] **Step 1: Create `lua/plugins/git/gitsigns.lua`**

Consult latest gitsigns.nvim docs via context7.

```lua
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    current_line_blame = false, -- toggled via keymap
    current_line_blame_opts = {
      delay = 300,
      virt_text_pos = "eol",
    },
  },
}
```

- [ ] **Step 2: Verify gitsigns**

Run: `nvim init.lua` (tracked file), make a change — green bar should appear in sign column next to changed line.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/git/gitsigns.lua
git commit -m "feat(git): add gitsigns with sign column indicators"
```

---

## Task 14: Terminal — toggleterm.nvim

**Files:**
- Create: `lua/plugins/tools/toggleterm.lua`

- [ ] **Step 1: Create `lua/plugins/tools/toggleterm.lua`**

Consult latest toggleterm.nvim docs via context7.

```lua
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = "ToggleTerm",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = false, -- keymaps handled in keymaps.lua
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = false,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    shell = "nu", -- Nushell
    float_opts = {
      border = "rounded",
      winblend = 0,
    },
  },
}
```

- [ ] **Step 2: Verify terminal**

Run: `nvim`, then `:ToggleTerm direction=horizontal` — terminal split should open at bottom with Nushell. `:ToggleTerm direction=float` — floating terminal.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/tools/toggleterm.lua
git commit -m "feat(tools): add toggleterm with nushell and split/float modes"
```

---

## Task 15: Debug — nvim-dap + UI + virtual-text

**Files:**
- Create: `lua/plugins/debug/dap.lua`

- [ ] **Step 1: Create `lua/plugins/debug/dap.lua`**

Consult latest nvim-dap, nvim-dap-ui, and nvim-dap-virtual-text docs via context7. Verify js-debug-adapter setup for Windows paths.

```lua
return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")

      -- Signs
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DapStopped" })
      vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DapBreakpointRejected" })

      -- JS/TS adapter (js-debug-adapter via mason)
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      -- Node.js / TypeScript
      for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Python adapter (debugpy via mason)
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/.venv/Scripts/python.exe") == 1 then
              return cwd .. "/.venv/Scripts/python.exe"
            else
              return "python"
            end
          end,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
        floating = { border = "rounded" },
      })

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {
      commented = true,
    },
  },
}
```

- [ ] **Step 2: Verify DAP setup**

Run: `nvim`, then `:lua require("dap")` — should load without errors. Check `:Mason` for js-debug-adapter and debugpy installed.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/debug/dap.lua
git commit -m "feat(debug): add nvim-dap with JS/TS/Python adapters and DAP UI"
```

---

## Task 16: Tests — neotest + Adapters

**Files:**
- Create: `lua/plugins/test/neotest.lua`

- [ ] **Step 1: Create `lua/plugins/test/neotest.lua`**

Consult latest neotest and adapter docs via context7.

```lua
return {
  "nvim-neotest/neotest",
  cmd = "Neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-python",
    "sidlatau/neotest-dart",
  },
  config = function()
    require("neotest").setup({
      icons = {
        failed = " ",
        passed = " ",
        running = " ",
        skipped = " ",
        unknown = " ",
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = true,
      },
      adapters = {
        require("neotest-jest")({
          jestCommand = "npx jest",
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-vitest"),
        require("neotest-python")({
          runner = "pytest",
          python = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/.venv/Scripts/python.exe") == 1 then
              return cwd .. "/.venv/Scripts/python.exe"
            end
            return "python"
          end,
        }),
        require("neotest-dart")({
          command = "flutter",
        }),
      },
    })
  end,
}
```

- [ ] **Step 2: Verify neotest**

Run: `nvim`, then `:Neotest summary` — should open test summary panel (empty if no tests). No errors on load.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/test/neotest.lua
git commit -m "feat(test): add neotest with jest, vitest, pytest, dart adapters"
```

---

## Task 17: Notebooks — molten.nvim + jupytext

**Files:**
- Create: `lua/plugins/notebook/molten.lua`

- [ ] **Step 1: Create `lua/plugins/notebook/molten.lua`**

Consult latest molten.nvim docs via context7. Verify Windows compatibility and WezTerm image protocol support.

```lua
return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    ft = { "python", "quarto" },
    build = ":UpdateRemotePlugins",
    dependencies = {
      "3rd/image.nvim",
    },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
  },
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty", -- WezTerm supports kitty image protocol
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
    },
  },
  {
    -- Jupytext for .ipynb <-> .py conversion
    "GCBallesteros/jupytext.nvim",
    ft = { "ipynb" },
    opts = {
      style = "hydrogen",
      output_extension = "auto",
      force_ft = nil,
    },
  },
}
```

- [ ] **Step 2: Verify molten**

Note: molten.nvim requires Python packages `pynvim` and `jupyter_client` installed. Run:
```bash
pip install pynvim jupyter_client cairosvg
```

Run: `nvim test.py`, execute `:MoltenInit` — should connect to a kernel. If no kernel available, verify Jupyter is installed.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/notebook/molten.lua
git commit -m "feat(notebook): add molten.nvim with jupytext for notebooks"
```

---

## Task 18: Utility Plugins — auto-session, overseer, arrow

**Files:**
- Create: `lua/plugins/session/auto-session.lua`
- Create: `lua/plugins/tasks/overseer.lua`
- Create: `lua/plugins/tools/arrow.lua`

- [ ] **Step 1: Create `lua/plugins/session/auto-session.lua`**

Consult latest auto-session docs via context7.

```lua
return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    auto_restore = true,
    auto_save = true,
    auto_create = true,
    suppressed_dirs = { "~/", "~/Downloads", "/" },
    bypass_save_filetypes = { "alpha", "neo-tree" },
  },
}
```

- [ ] **Step 2: Create `lua/plugins/tasks/overseer.lua`**

Consult latest overseer.nvim docs via context7.

```lua
return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerOpen" },
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 10,
      max_height = 25,
      default_detail = 1,
    },
    templates = { "builtin" },
    icons = {
      CANCELED = " ",
      FAILURE = " ",
      RUNNING = " ",
      SUCCESS = " ",
    },
  },
}
```

- [ ] **Step 3: Create `lua/plugins/tools/arrow.lua`**

Consult latest arrow.nvim docs via context7.

```lua
return {
  "otavioschwanck/arrow.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    show_icons = true,
    leader_key = ";",
    buffer_leader_key = "m",
  },
}
```

- [ ] **Step 4: Verify all three**

- `nvim` + `:qa` + `nvim` in same dir — session should restore
- `:OverseerRun` — should show available task templates
- Press `;` — arrow.nvim should open file picker

- [ ] **Step 5: Commit**

```bash
git add lua/plugins/session/auto-session.lua lua/plugins/tasks/overseer.lua lua/plugins/tools/arrow.lua
git commit -m "feat: add auto-session, overseer task runner, and arrow bookmarks"
```

---

## Task 19: Additional Tools — bruno, docker, markdown

**Files:**
- Create: `lua/plugins/tools/bruno.lua`
- Create: `lua/plugins/tools/docker.lua`
- Create: `lua/plugins/tools/markdown.lua`

- [ ] **Step 1: Create `lua/plugins/tools/bruno.lua`**

Consult `https://github.com/romek-codes/bruno.nvim` README for setup.

```lua
return {
  "romek-codes/bruno.nvim",
  cmd = { "BrunoRun", "BrunoEnv", "BrunoSearch" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    picker = "telescope",
    show_formatted_output = true,
    suppress_formatting_errors = false,
    -- collection_paths configured per-project via project.lua or .nvim.lua
    collection_paths = {},
  },
}
```

- [ ] **Step 2: Create `lua/plugins/tools/docker.lua`**

Search for a suitable docker.nvim plugin and consult its docs. A common option is `dgrbrady/nvim-docker` or similar.

```lua
return {
  "dgrbrady/nvim-docker",
  cmd = { "Docker" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {},
}
```

Note: Verify the best Docker plugin available at implementation time. If `nvim-docker` is not well maintained, consider `mgierada/lazydocker.nvim` which integrates lazydocker as a float terminal — simpler and more reliable.

- [ ] **Step 3: Create `lua/plugins/tools/markdown.lua`**

Consult latest render-markdown.nvim and markdown-preview.nvim docs via context7.

```lua
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      heading = {
        enabled = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "  " },
        checked = { icon = "  " },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
```

- [ ] **Step 4: Verify tools**

- Open a `.md` file — render-markdown should format headers, bullets, checkboxes inline
- `:MarkdownPreview` — should open browser with preview
- `:BrunoRun` — should show error about no collection (expected without config)

- [ ] **Step 5: Commit**

```bash
git add lua/plugins/tools/bruno.lua lua/plugins/tools/docker.lua lua/plugins/tools/markdown.lua
git commit -m "feat(tools): add bruno, docker, and markdown plugins"
```

---

## Task 20: Keymaps + Which-Key (Centralized)

**Files:**
- Create: `lua/config/keymaps.lua`

This is the most critical file — ALL keymaps live here. No plugin defines its own keymaps.

- [ ] **Step 1: Create `lua/config/keymaps.lua` — Core keymaps**

```lua
local map = vim.keymap.set

-- ============================================================
-- CORE KEYMAPS (no plugin dependency)
-- ============================================================

-- Better escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Navigate splits
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase split height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease split height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease split width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase split width" })

-- Buffer navigation
map("n", "H", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Terminal mode escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Move to left split" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Move to below split" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Move to above split" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Move to right split" })
```

- [ ] **Step 2: Add Which-Key plugin spec**

Create a which-key spec that gets loaded by lazy.nvim. Add to the keymaps file or as a separate plugin file. Since which-key is tightly coupled to keymaps, keep it in `lua/config/keymaps.lua` is not ideal because lazy.nvim needs plugin specs in `lua/plugins/`. Create `lua/plugins/ui/which-key.lua`:

```lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "",
      rules = false, -- use custom icons below
    },
    spec = {
      { "<leader>f", group = " Find", icon = "" },
      { "<leader>e", group = " Explorer", icon = "" },
      { "<leader>l", group = " LSP", icon = "" },
      { "<leader>g", group = " Git", icon = "" },
      { "<leader>d", group = " Debug", icon = "" },
      { "<leader>t", group = " Terminal", icon = "" },
      { "<leader>n", group = " Tests", icon = "" },
      { "<leader>r", group = " Run", icon = "" },
      { "<leader>s", group = " Session", icon = "" },
      { "<leader>b", group = " Buffers", icon = "" },
      { "<leader>m", group = " Markdown", icon = "" },
      { "<leader>o", group = " Notebook", icon = "" },
      { "<leader>k", group = " Docker", icon = "" },
    },
  },
}
```

- [ ] **Step 3: Add plugin keymaps to `lua/config/keymaps.lua`**

Append to the keymaps file:

```lua
-- ============================================================
-- PLUGIN KEYMAPS
-- ============================================================

-- [F]ind (Telescope)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Todo comments" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Grep word under cursor" })

-- [E]xplorer (Neo-tree)
map("n", "<leader>ee", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>ef", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file" })
map("n", "<leader>eg", "<cmd>Neotree git_status<cr>", { desc = "Git status explorer" })
map("n", "<leader>eb", "<cmd>Neotree buffers<cr>", { desc = "Buffer explorer" })

-- [L]SP
map("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
map("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
map("n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })
map("n", "<leader>lf", "<cmd>lua require('conform').format({ async = true })<cr>", { desc = "Format" })
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
map("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })
map("n", "<leader>ll", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Line diagnostics" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next diagnostic" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Prev diagnostic" })

-- [G]it
map("n", "<leader>gg", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    float_opts = { border = "rounded" },
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  lazygit:toggle()
end, { desc = "Lazygit" })
map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle blame" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage buffer" })
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev hunk" })

-- [D]ebug (DAP)
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle breakpoint" })
map("n", "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", { desc = "Conditional breakpoint" })
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<cr>", { desc = "Continue" })
map("n", "<leader>di", "<cmd>lua require('dap').step_into()<cr>", { desc = "Step into" })
map("n", "<leader>do", "<cmd>lua require('dap').step_over()<cr>", { desc = "Step over" })
map("n", "<leader>dO", "<cmd>lua require('dap').step_out()<cr>", { desc = "Step out" })
map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", { desc = "Toggle DAP UI" })
map("n", "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>", { desc = "Toggle REPL" })
map("n", "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", { desc = "Run last" })
map("n", "<leader>dt", "<cmd>lua require('dap').terminate()<cr>", { desc = "Terminate" })

-- [T]erminal
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })

-- [N]eotest
map("n", "<leader>nr", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run nearest" })
map("n", "<leader>nf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run file" })
map("n", "<leader>ns", "<cmd>lua require('neotest').run.run({ suite = true })<cr>", { desc = "Run suite" })
map("n", "<leader>no", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", { desc = "Output" })
map("n", "<leader>nS", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Summary" })
map("n", "<leader>nw", "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>", { desc = "Watch file" })

-- [R]un (Bruno + Overseer)
map("n", "<leader>rb", "<cmd>BrunoRun<cr>", { desc = "Bruno run" })
map("n", "<leader>re", "<cmd>BrunoEnv<cr>", { desc = "Bruno environment" })
map("n", "<leader>rs", "<cmd>BrunoSearch<cr>", { desc = "Bruno search" })
map("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Overseer toggle" })
map("n", "<leader>rr", "<cmd>OverseerRun<cr>", { desc = "Overseer run" })

-- [S]ession
map("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "Save session" })
map("n", "<leader>sr", "<cmd>SessionRestore<cr>", { desc = "Restore session" })
map("n", "<leader>sd", "<cmd>SessionDelete<cr>", { desc = "Delete session" })

-- [B]uffers
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bD", "<cmd>%bdelete<cr>", { desc = "Delete all buffers" })

-- [M]arkdown
map("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Preview in browser" })
map("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Stop preview" })
map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle render" })

-- N[o]tebook (Molten)
map("n", "<leader>oi", "<cmd>MoltenInit<cr>", { desc = "Initialize kernel" })
map("n", "<leader>or", "<cmd>MoltenEvaluateOperator<cr>", { desc = "Run operator" })
map("n", "<leader>ol", "<cmd>MoltenEvaluateLine<cr>", { desc = "Run line" })
map("v", "<leader>or", ":<C-u>MoltenEvaluateVisual<cr>gv", { desc = "Run selection" })
map("n", "<leader>oa", "<cmd>MoltenReevaluateAll<cr>", { desc = "Run all cells" })
map("n", "<leader>on", "<cmd>MoltenNext<cr>", { desc = "Next cell" })
map("n", "<leader>op", "<cmd>MoltenPrev<cr>", { desc = "Previous cell" })
map("n", "<leader>od", "<cmd>MoltenDelete<cr>", { desc = "Delete cell output" })

-- Doc[k]er
map("n", "<leader>kl", "<cmd>Docker<cr>", { desc = "Docker list" })
```

- [ ] **Step 4: Verify keymaps + which-key**

Run: `nvim`, press `<Space>` and wait 300ms — which-key popup should appear with all groups and icons. Navigate into `<leader>f` — should show all Find keymaps. Press `<leader>ff` — should open Telescope find_files.

- [ ] **Step 5: Commit**

```bash
git add lua/config/keymaps.lua lua/plugins/ui/which-key.lua
git commit -m "feat: add centralized keymaps with which-key groups and icons"
```

---

## Task 21: Project Detection

**Files:**
- Create: `lua/config/project.lua`

- [ ] **Step 1: Create `lua/config/project.lua`**

```lua
local M = {}

-- Detect project type based on root files
function M.detect()
  local cwd = vim.fn.getcwd()
  local types = {}

  local markers = {
    node = { "package.json" },
    python = { "pyproject.toml", "requirements.txt", "setup.py", "Pipfile" },
    flutter = { "pubspec.yaml" },
    docker = { "docker-compose.yml", "docker-compose.yaml", "Dockerfile" },
    bruno = { "collection.bru", "bruno.json" },
  }

  for project_type, files in pairs(markers) do
    for _, file in ipairs(files) do
      if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
        types[project_type] = true
        break
      end
    end
  end

  -- Check for notebooks
  local ipynb_files = vim.fn.glob(cwd .. "/*.ipynb", false, true)
  if #ipynb_files > 0 then
    types.notebook = true
  end

  return types
end

-- Configure tools based on detected project type
function M.setup()
  local types = M.detect()

  -- Node.js projects: ensure eslint_d and prettierd are active
  if types.node then
    -- neotest picks up jest/vitest automatically via adapter detection
    vim.g.project_has_node = true
  end

  -- Python projects
  if types.python then
    vim.g.project_has_python = true
  end

  -- Flutter projects
  if types.flutter then
    vim.g.project_has_flutter = true
  end

  -- Docker projects
  if types.docker then
    vim.g.project_has_docker = true
  end

  -- Bruno collections
  if types.bruno then
    vim.g.project_has_bruno = true
  end

  -- Notebook projects
  if types.notebook then
    vim.g.project_has_notebook = true
  end
end

-- Run detection on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("project_detect", { clear = true }),
  callback = function()
    M.setup()
  end,
})

return M
```

- [ ] **Step 2: Load project detection in init.lua**

Add to `init.lua` after keymaps:

```lua
require("config.project")
```

- [ ] **Step 3: Verify project detection**

Run: `nvim` in a Node.js project directory, then `:lua print(vim.g.project_has_node)` — should print `true`.
Run in a Python project: `:lua print(vim.g.project_has_python)` — should print `true`.

- [ ] **Step 4: Commit**

```bash
git add lua/config/project.lua init.lua
git commit -m "feat: add project type detection for conditional tool activation"
```

---

## Task 22: Final Verification + Polish

- [ ] **Step 1: Run full health check**

```
nvim -c 'checkhealth'
```

Review output for warnings/errors in: LSP, Treesitter, mason, DAP. Fix any issues found.

- [ ] **Step 2: Verify startup time**

```
nvim --startuptime /tmp/nvim-startup.log -c 'qa'
```

Check `/tmp/nvim-startup.log`. Target: under 100ms with lazy loading. If slow, identify plugins loading eagerly that should be lazy.

- [ ] **Step 3: Test each major feature**

Run through each group quickly:
- `<leader>ff` — Telescope find files
- `<leader>ee` — Neo-tree toggle
- `<leader>gg` — Lazygit
- `<leader>th` — Terminal split
- Open a `.lua` file — LSP attaches, completion works
- Open a `.md` file — render-markdown formats
- `<leader>` — which-key shows all groups with icons

- [ ] **Step 4: Fix any issues found**

Address any errors, missing icons, wrong keymaps, or broken plugins.

- [ ] **Step 5: Final commit**

```bash
git add -A
git commit -m "feat: complete Neovim IDE configuration — all plugins verified"
```

---

## Summary

| Task | Description | Estimated Steps |
|------|-------------|-----------------|
| 1 | Core bootstrap | 6 |
| 2 | Icons + Colorscheme | 4 |
| 3 | Statusline (lualine) | 3 |
| 4 | Dashboard (alpha) | 3 |
| 5 | Notifications (noice + fidget) | 4 |
| 6 | Treesitter + textobjects | 3 |
| 7 | Editor essentials | 7 |
| 8 | Telescope | 3 |
| 9 | Neo-tree | 3 |
| 10 | LSP + Mason | 4 |
| 11 | Completion (blink.cmp) | 4 |
| 12 | Formatting + Linting | 4 |
| 13 | Git (gitsigns) | 3 |
| 14 | Terminal (toggleterm) | 3 |
| 15 | Debug (DAP + UI) | 3 |
| 16 | Tests (neotest) | 3 |
| 17 | Notebooks (molten) | 3 |
| 18 | Utilities (session, overseer, arrow) | 5 |
| 19 | Additional tools (bruno, docker, markdown) | 5 |
| 20 | Keymaps + Which-Key | 5 |
| 21 | Project detection | 4 |
| 22 | Final verification | 5 |
| **Total** | | **83 steps** |
