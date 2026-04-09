<div align="center">

```
       ███╗   ██╗██╗   ██╗██╗███╗   ███╗
       ████╗  ██║██║   ██║██║████╗ ████║
       ██╔██╗ ██║██║   ██║██║██╔████╔██║
       ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
       ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
       ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```

**A minimal, fast Neovim configuration built entirely on native features.**

No lazy.nvim. No external plugin manager. Just `vim.pack` and Neovim 0.12.

[![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?style=flat-square&logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-100%25-2C2D72?style=flat-square&logo=lua&logoColor=white)](https://www.lua.org)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)

</div>

---

## Philosophy

This config prioritizes **built-in Neovim features** over third-party abstractions:

- **`vim.pack`** for plugin management (no lazy.nvim, no packer)
- **Native LSP** completion with `vim.lsp.completion` (no nvim-cmp, no blink.cmp)
- **Native treesitter** highlighting via `vim.treesitter.start()` (no `nvim-treesitter` highlight module)
- **`vim.snippet`** for snippet expansion (no LuaSnip)
- **Native folding** with treesitter + LSP foldexpr

Plugins are used only when Neovim doesn't provide a built-in equivalent.

## Features

| Category           | Details                                                      |
| ------------------ | ------------------------------------------------------------ |
| **Plugin Manager** | `vim.pack` (Neovim 0.12 built-in)                            |
| **Completion**     | Native LSP completion with fuzzy matching                    |
| **Snippets**       | `vim.snippet` with custom snippets for TS, Python, Dart, Lua |
| **LSP**            | 12 language servers auto-installed via Mason                 |
| **Formatting**     | conform.nvim (prettierd, black, stylua)                      |
| **Linting**        | nvim-lint (eslint_d, ruff, luacheck, markdownlint, hadolint) |
| **Debugging**      | nvim-dap with adapters for JS/TS and Python                  |
| **Testing**        | neotest with Jest, Vitest, pytest, and Dart runners          |
| **File Explorer**  | Neo-tree                                                     |
| **Fuzzy Finder**   | Telescope                                                    |
| **Git**            | Gitsigns + Lazygit integration                               |
| **Terminal**       | ToggleTerm (horizontal, vertical, float)                     |
| **Statusline**     | Lualine with custom LSP client display                       |
| **Dashboard**      | alpha-nvim with quick actions                                |
| **Keymaps**        | mini.clue for discoverability                                |
| **Colorscheme**    | Oasis (lagoon style)                                         |
| **Notebooks**      | Molten.nvim for Jupyter REPL                                 |

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   └── config/
│       ├── options.lua      # Editor settings, diagnostics, LSP UI
│       ├── plugins.lua      # vim.pack declarations + Mason setup
│       ├── keymaps.lua      # All keymaps + mini.clue config
│       ├── autocmds.lua     # Autocommands (LSP attach, treesitter, etc.)
│       ├── snippets.lua     # Custom snippets (TS, Python, Dart, Lua)
│       └── project.lua      # Project type detection
├── lsp/                     # Per-server LSP configurations
│   ├── ts_ls.lua
│   ├── pyright.lua
│   ├── lua_ls.lua
│   └── ...                  # 12 servers total
├── plugin/                  # Plugin configs (auto-loaded by Neovim)
│   ├── alpha.lua            # Dashboard
│   ├── telescope.lua        # Fuzzy finder
│   ├── neo-tree.lua         # File explorer
│   ├── lualine.lua          # Statusline
│   ├── dap.lua              # Debug adapters
│   ├── neotest.lua          # Test runner
│   └── ...                  # 22 plugin configs
└── scripts/
    └── install-deps.sh      # Cross-platform dependency installer
```

> **Why `plugin/` instead of `lua/plugins/`?** This config uses `vim.pack`, not lazy.nvim. The `plugin/` directory is Neovim's native auto-load mechanism — files there run automatically at startup without explicit `require()` calls.

## Requirements

- **Neovim** >= 0.12 (nightly)
- **Git** >= 2.19
- **Node.js** >= 18 (for LSP servers and formatters)
- **Python** >= 3.10 (for pyright, debugpy, molten)
- **ripgrep** (for Telescope live grep)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)

### Optional

- **lazygit** — Git TUI (mapped to `<leader>gg`)
- **Flutter SDK** — for Dart/Flutter development
- **ImageMagick** — for inline image rendering in Molten

## Installation

### 1. Clone

```bash
git clone https://github.com/bgarciamoura/nvim.git ~/.config/nvim
```

### 2. Install dependencies

The included script handles everything across macOS, Linux, and Windows:

```bash
~/.config/nvim/scripts/install-deps.sh
```

<details>
<summary>What it installs</summary>

**System:** git, node, python, ripgrep, curl, unzip, imagemagick

**Python packages:** pynvim, jupyter_client, nbformat, cairosvg, pillow, pyperclip

**Verified automatically:** Flutter/Dart SDK, image-capable terminal (Kitty/WezTerm)

</details>

### 3. Launch Neovim

```bash
nvim
```

On first launch, `vim.pack` will clone all plugins. Mason will then install LSP servers, formatters, linters, and DAP adapters automatically.

### 4. Verify

```vim
:checkhealth
:Mason
```

## Keymaps

Leader key: `Space`

Press `<Space>` and wait 300ms to see all available keymaps via mini.clue.

### General

| Key               | Action               |
| ----------------- | -------------------- |
| `jk`              | Exit insert mode     |
| `<C-s>`           | Save file            |
| `<C-q>`           | Quit Neovim          |
| `<C-a>`           | Select all           |
| `<C-z>` / `<C-y>` | Undo / Redo          |
| `<leader>;`       | Toggle comment       |
| `<leader>q`       | Close buffer or quit |

### Navigation

| Key               | Action                      |
| ----------------- | --------------------------- |
| `<C-h/j/k/l>`     | Navigate between windows    |
| `<S-h>` / `<S-l>` | Previous / Next buffer      |
| `<C-d>` / `<C-u>` | Scroll down / up (centered) |
| `<A-j>` / `<A-k>` | Move line(s) down / up      |

### Find (`<leader>f`)

| Key              | Action           |
| ---------------- | ---------------- |
| `<Space><Space>` | Find files       |
| `<leader>fg`     | Live grep        |
| `<leader>fb`     | Buffers          |
| `<leader>fr`     | Recent files     |
| `<leader>fs`     | Document symbols |
| `<leader>fd`     | Diagnostics      |
| `<leader>ft`     | Todo comments    |

### LSP (`<leader>l`)

| Key                 | Action           |
| ------------------- | ---------------- |
| `gd` / `<leader>ld` | Go to definition |
| `<leader>lr`        | References       |
| `<leader>ln`        | Rename           |
| `<leader>la`        | Code action      |
| `<leader>lf`        | Format           |
| `<leader>lh`        | Hover            |
| `<leader>ll`        | Line diagnostics |

### Git (`<leader>g`)

| Key                         | Action               |
| --------------------------- | -------------------- |
| `<leader>gg`                | Open Lazygit         |
| `<leader>gb`                | Toggle line blame    |
| `<leader>gp`                | Preview hunk         |
| `<leader>gs` / `<leader>gS` | Stage hunk / buffer  |
| `<leader>gd`                | Diff                 |
| `]h` / `[h`                 | Next / Previous hunk |

### Debug (`<leader>d`)

| Key                         | Action                 |
| --------------------------- | ---------------------- |
| `<leader>db`                | Toggle breakpoint      |
| `<leader>dB`                | Conditional breakpoint |
| `<leader>dc`                | Continue               |
| `<leader>di` / `<leader>do` | Step into / over       |
| `<leader>du`                | Toggle DAP UI          |
| `<leader>dt`                | Terminate              |

### Tests (`<leader>n`)

| Key          | Action           |
| ------------ | ---------------- |
| `<leader>nr` | Run nearest test |
| `<leader>nf` | Run file tests   |
| `<leader>ns` | Run test suite   |
| `<leader>no` | Open output      |
| `<leader>nS` | Toggle summary   |

### Terminal (`<leader>t`)

| Key          | Action              |
| ------------ | ------------------- |
| `<leader>th` | Horizontal terminal |
| `<leader>tv` | Vertical terminal   |
| `<leader>tf` | Float terminal      |
| `<Esc><Esc>` | Exit terminal mode  |

### Jupyter (`<leader>j`)

| Key                         | Action                       |
| --------------------------- | ---------------------------- |
| `<leader>ji`                | Initialize Molten            |
| `<leader>jr`                | Evaluate (operator / visual) |
| `<leader>jl`                | Evaluate line                |
| `<leader>ja`                | Re-evaluate all              |
| `<leader>jn` / `<leader>jp` | Next / Previous cell         |

### Snippets

Type a prefix in insert mode and press `<C-l>` to expand.

<details>
<summary>Available snippets</summary>

**TypeScript / JavaScript:** `fn`, `afn`, `imp`, `impt`, `us`, `ue`, `cl`, `trycatch`

**Python:** `def`, `cls`, `ifmain`, `fori`, `with`, `lc`, `impnp`, `imppd`, `impplt`, `trycatch`

**Dart:** `stl`, `stf`, `build`, `init`

**Lua:** `fn`, `lfn`, `req`, `if`

</details>

## Language Support

### LSP Servers (auto-installed via Mason)

| Language                | Server                                     |
| ----------------------- | ------------------------------------------ |
| TypeScript / JavaScript | ts_ls                                      |
| Python                  | pyright + ruff                             |
| Lua                     | lua_ls                                     |
| JSON                    | jsonls (with SchemaStore)                  |
| YAML                    | yamlls (with SchemaStore)                  |
| HTML                    | html                                       |
| CSS                     | cssls                                      |
| TOML                    | taplo                                      |
| Markdown                | marksman                                   |
| Docker                  | dockerls + docker_compose_language_service |
| Dart / Flutter          | flutter-tools.nvim (dartls)                |

### Formatters

| Tool      | Languages                               |
| --------- | --------------------------------------- |
| prettierd | JS, TS, HTML, CSS, JSON, YAML, Markdown |
| black     | Python                                  |
| stylua    | Lua                                     |

### Linters

| Tool         | Languages  |
| ------------ | ---------- |
| eslint_d     | JS, TS     |
| ruff         | Python     |
| luacheck     | Lua        |
| markdownlint | Markdown   |
| hadolint     | Dockerfile |

## License

MIT
