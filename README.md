<div align="center">

# Neovim

**A fast, fully-featured Neovim configuration built for real work.**

Lua-native. Lazy-loaded. Zero compromise.

![Neovim](https://img.shields.io/badge/Neovim-0.12%2B-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-100%25-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-blue?style=for-the-badge)

</div>

---

## Why This Config?

Most Neovim configs are either too bloated or too minimal. This one is neither.

- **Native LSP** -- uses Neovim 0.12's built-in `vim.lsp.config()` API directly. No nvim-lspconfig.
- **Everything lazy-loaded** -- plugins load only when needed. Startup stays fast.
- **One keymap file** -- all keybindings in a single place. No hunting across 30 files.
- **Batteries included** -- LSP, completion, formatting, linting, debugging, testing, git, notebooks, REST client, Docker -- all configured and ready to go.

---

## Features at a Glance

| Category | What You Get |
|---|---|
| **Completion** | [blink.cmp](https://github.com/saghen/blink.cmp) with snippets |
| **LSP** | 12 servers, native Neovim 0.12 API, auto-installed via Mason |
| **Formatting** | Format-on-save via [conform.nvim](https://github.com/stevearc/conform.nvim) |
| **Linting** | Real-time via [nvim-lint](https://github.com/mfussenegger/nvim-lint) |
| **Debugging** | Full DAP setup for JS/TS, Python, Dart |
| **Testing** | [neotest](https://github.com/nvim-neotest/neotest) with Jest, Vitest, pytest, Dart |
| **Git** | Gitsigns + Lazygit integration |
| **File Explorer** | [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) with git status |
| **Search** | [Telescope](https://github.com/nvim-telescope/telescope.nvim) + [grug-far](https://github.com/MagicDuck/grug-far.nvim) for find & replace |
| **Notebooks** | [Molten](https://github.com/benlubas/molten-nvim) + Jupytext for interactive Python |
| **REST Client** | [Bruno.nvim](https://github.com/romek-codes/bruno.nvim) for API testing |
| **Docker** | [LazyDocker](https://github.com/mgierada/lazydocker.nvim) inside Neovim |
| **Theme** | [Oasis](https://github.com/uhs-robert/oasis.nvim) (Lagoon) + 5 alternatives |
| **UI** | Noice command palette, which-key hints, fidget progress, custom lualine |

---

## Installation

### Prerequisites

- **Neovim >= 0.12** (required -- uses native LSP API)
- **Git**
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal
- **Node.js** (for LSP servers and formatters)
- **Python 3** + `pip` (for Python tooling)

### Quick Start

**Back up your current config first:**

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

**Clone:**

```bash
git clone https://github.com/bgarciamoura/neovim.git ~/.config/nvim
```

**Open Neovim:**

```bash
nvim
```

Lazy.nvim will bootstrap itself and install all plugins automatically. Mason will install LSP servers, formatters, and linters on first run.

---

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point: loads core, bootstraps lazy.nvim
├── lua/
│   ├── core/
│   │   ├── options.lua         # Editor settings (tabs, search, folds, etc.)
│   │   └── autocmds.lua        # Autocommands (yank highlight, trailing ws, etc.)
│   ├── config/
│   │   ├── keymaps.lua         # ALL keybindings in one file
│   │   └── project.lua         # Project-type detection
│   └── plugins/
│       ├── ui/                 # Theme, statusline, dashboard, which-key, noice
│       ├── editor/             # Treesitter, autopairs, comments, surround, TODO
│       ├── lsp/                # LSP configs, Mason, completion, formatting, linting
│       ├── tools/              # Telescope, neo-tree, terminal, grug-far, Docker
│       ├── git/                # Gitsigns
│       ├── debug/              # DAP + adapters
│       ├── test/               # Neotest + adapters
│       ├── notebook/           # Molten + Jupytext
│       ├── session/            # Auto-session
│       └── tasks/              # Overseer task runner
```

---

## Keybindings

Leader key is `<Space>`. All keybindings are in [`lua/config/keymaps.lua`](lua/config/keymaps.lua).

### Essentials

| Key | Action |
|---|---|
| `jk` | Exit insert mode |
| `<C-s>` | Save file |
| `<C-q>` | Quit |
| `<C-a>` | Select all |
| `<Esc>` | Clear search highlight |
| `<Space><Space>` | Quick find files |

### Navigation

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Navigate between splits |
| `H` / `L` | Previous / next buffer |
| `<A-j>` / `<A-k>` | Move line up / down |
| `]d` / `[d` | Next / previous diagnostic |
| `]h` / `[h` | Next / previous git hunk |

### Find (`<leader>f`)

| Key | Action |
|---|---|
| `ff` | Find files |
| `fg` | Live grep |
| `fb` | Buffers |
| `fr` | Recent files |
| `fs` | Document symbols |
| `fw` | Grep word under cursor |
| `ft` | TODO comments |
| `fd` | Diagnostics |
| `fR` | Find and Replace (grug-far) |

### Explorer (`<leader>e`)

| Key | Action |
|---|---|
| `e` | Toggle file tree |
| `ef` | Reveal current file |
| `eg` | Git status |
| `eb` | Buffers |

### LSP (`<leader>l`)

| Key | Action |
|---|---|
| `ld` | Go to definition |
| `lr` | References |
| `ln` | Rename |
| `la` | Code action |
| `lf` | Format |
| `lh` | Hover |
| `ls` | Signature help |
| `lt` | Type definition |
| `ll` | Line diagnostics |

### Git (`<leader>g`)

| Key | Action |
|---|---|
| `gg` | Open Lazygit |
| `gb` | Toggle blame |
| `gp` | Preview hunk |
| `gs` / `gS` | Stage hunk / buffer |
| `gr` / `gR` | Reset hunk / buffer |
| `gd` | Diff this |

### Debug (`<leader>d`)

| Key | Action |
|---|---|
| `db` | Toggle breakpoint |
| `dB` | Conditional breakpoint |
| `dc` | Continue |
| `di` / `do` / `dO` | Step into / over / out |
| `du` | Toggle DAP UI |
| `dr` | Toggle REPL |
| `dt` | Terminate |

### Tests (`<leader>n`)

| Key | Action |
|---|---|
| `nr` | Run nearest test |
| `nf` | Run file tests |
| `ns` | Run test suite |
| `no` | Open output |
| `nS` | Toggle summary |

### Terminal (`<leader>t`)

| Key | Action |
|---|---|
| `th` | Horizontal terminal |
| `tv` | Vertical terminal |
| `tf` | Floating terminal |

### More

| Prefix | Category |
|---|---|
| `<leader>r` | Run (Bruno REST client, Overseer tasks) |
| `<leader>s` | Session (save, restore, delete) |
| `<leader>b` | Buffers (delete, next, previous) |
| `<leader>m` | Markdown (preview, render) |
| `<leader>o` | Notebooks (Molten evaluate, navigate cells) |
| `<leader>k` | Docker (LazyDocker) |

> Press `<Space>` and wait -- [which-key](https://github.com/folke/which-key.nvim) will show all available options.

---

## Language Support

### LSP Servers

All servers are auto-installed via [Mason](https://github.com/mason-org/mason.nvim) and configured with Neovim 0.12's native LSP API.

| Language | Server | Features |
|---|---|---|
| TypeScript / JavaScript | ts_ls | Inlay hints, auto-imports |
| Python | pyright | Type checking, workspace diagnostics |
| Lua | lua_ls | Neovim API completions |
| JSON | jsonls | SchemaStore validation |
| YAML | yamlls | SchemaStore (Docker Compose, K8s, CI) |
| HTML | html | |
| CSS / SCSS / LESS | cssls | |
| TOML | taplo | |
| Markdown | marksman | |
| Dockerfile | dockerls | |
| Docker Compose | docker_compose_language_service | |
| Dart / Flutter | flutter-tools | Hot reload, device picker |

### Formatters (format-on-save)

| Language | Formatter |
|---|---|
| JavaScript / TypeScript / Web | prettierd |
| Python | black |
| Lua | stylua |
| Dart | dart format |

### Linters

| Language | Linter |
|---|---|
| JavaScript / TypeScript | eslint_d |
| Python | ruff |
| Lua | luacheck |
| Markdown | markdownlint |
| Dockerfile | hadolint |

---

## Colorschemes

**Default: [Oasis](https://github.com/uhs-robert/oasis.nvim)** (Lagoon variant) -- a warm, accessible theme with WCAG-compliant contrast.

Switch anytime with `:colorscheme`:

```vim
:colorscheme oasis-lagoon      " Default
:colorscheme oasis-midnight     " Dark
:colorscheme oasis-desert       " Retro
:colorscheme catppuccin-mocha   " Popular dark
:colorscheme tokyonight-storm   " Vibrant dark
:colorscheme rose-pine          " Soft dark
:colorscheme cyberdream         " Neon
:colorscheme vague              " Minimal
```

---

## Adding a Plugin

1. Create a file in `lua/plugins/<category>/pluginname.lua`
2. Return a [lazy.nvim spec table](https://lazy.folke.io/spec)
3. Add keymaps to `lua/config/keymaps.lua`
4. If it needs a Mason package, add to `ensure_installed` in `lua/plugins/lsp/mason.lua`

That's it. Lazy.nvim auto-discovers plugin files.

---

## Design Decisions

| Decision | Rationale |
|---|---|
| **Native LSP (no nvim-lspconfig)** | Neovim 0.12 provides `vim.lsp.config()` + `vim.lsp.enable()`. One less dependency. |
| **All keymaps in one file** | Easy to find, easy to change, no surprises. |
| **Treesitter highlight via native API** | `vim.treesitter.start()` is more reliable than nvim-treesitter's highlight module on 0.12. |
| **Format via conform, not LSP** | Consistent behavior, format-on-save with timeout, multiple formatters per filetype. |
| **No tabline, no winbar** | Less clutter. Buffers are navigated via Telescope or `H`/`L`. |
| **All plugins lazy by default** | Only load what you use. Every millisecond counts. |

---

## License

MIT

