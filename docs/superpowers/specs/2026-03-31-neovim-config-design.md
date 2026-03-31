# Neovim Configuration Design Spec

## Overview

Full IDE-like Neovim 0.12.0 configuration built from scratch on Windows (Nushell + WezTerm). Modular by domain, lazy-loaded, with project-aware tooling and centralized keymaps.

## Target Stack

- **Languages:** TypeScript, JavaScript, Python, Lua, Dart
- **Frameworks:** React, React Native, Expo, Next.js, Nest.js, Flutter
- **Notebooks:** Jupyter (.ipynb) for Machine Learning
- **API Client:** Bruno

## Architecture — Modular by Domain

```
init.lua                    -- entry point: loads core + bootstraps lazy.nvim
lua/
  core/
    init.lua                -- loads options + autocmds
    options.lua             -- vim.opt settings
    autocmds.lua            -- global autocommands
  config/
    keymaps.lua             -- ALL keymaps centralized (core + plugins)
    project.lua             -- project type detection + conditional activation
  plugins/
    editor/
      treesitter.lua        -- nvim-treesitter + textobjects
      autopairs.lua         -- nvim-autopairs
      surround.lua          -- nvim-surround
      comment.lua           -- Comment.nvim + ts-context-commentstring
      todo.lua              -- todo-comments.nvim
      colorizer.lua         -- nvim-colorizer
    ui/
      colorscheme.lua       -- catppuccin / tokyonight / rose-pine (switchable)
      statusline.lua        -- lualine.nvim (informative mode)
      dashboard.lua         -- alpha-nvim with ASCII art
      noice.lua             -- noice.nvim (cmdline, messages, notifications)
      fidget.lua            -- fidget.nvim (LSP progress)
      icons.lua             -- nvim-web-devicons (Material Design, colorful)
    lsp/
      lsp.lua               -- native vim.lsp.config() + vim.lsp.enable()
      mason.lua             -- mason.nvim (tool installer only)
      conform.lua           -- conform.nvim (formatting)
      lint.lua              -- nvim-lint (linting)
      blink.lua             -- blink.cmp (completion)
    tools/
      telescope.lua         -- telescope.nvim + fzf-native + ui-select
      neo-tree.lua          -- neo-tree.nvim (sidebar, colorful Material icons)
      toggleterm.lua        -- toggleterm.nvim (split default, float optional)
      bruno.lua             -- bruno.nvim (API client)
      docker.lua            -- docker.nvim
      markdown.lua          -- render-markdown.nvim + markdown-preview.nvim
      arrow.lua             -- arrow.nvim (file bookmarks)
    git/
      gitsigns.lua          -- gitsigns.nvim
    debug/
      dap.lua               -- nvim-dap + nvim-dap-ui + nvim-dap-virtual-text
    test/
      neotest.lua           -- neotest + adapters (jest, vitest, python, dart)
    notebook/
      molten.lua            -- molten.nvim + jupytext
    session/
      auto-session.lua      -- auto-session
    tasks/
      overseer.lua          -- overseer.nvim
```

## Core

### options.lua

- Leader: `<Space>`, local leader: `\`
- Relative line numbers
- Tabs: 2 spaces (default, overridable per filetype)
- Clipboard: system (`unnamedplus`)
- Search: case-insensitive with smartcase
- Splits: open right/below
- Scroll offset: 8 lines
- Persistent undofile
- termguicolors enabled
- signcolumn: "yes" (always visible)

### autocmds.lua

- Highlight on yank
- Remove trailing whitespace on save
- Restore cursor position on file reopen
- Auto-resize splits on window resize
- Close certain filetypes with `q` (help, qf, notify, etc.)

### init.lua (entry point)

- Load core (options + autocmds)
- Bootstrap lazy.nvim (auto-install if missing)
- Load all plugins from `lua/plugins/` subdirectories

## UI

### Colorscheme

Three themes installed, easily switchable:
- Catppuccin (Mocha)
- Tokyonight (Storm)
- Rose Pine (Main)

All with plugin integrations (telescope, neo-tree, blink, gitsigns, noice, etc.).

### Statusline — lualine.nvim

- **Left:** mode (with icon), git branch (icon), diff counts (+/-/~)
- **Center:** filename with relative path, diagnostics (errors/warnings/hints with icons)
- **Right:** filetype with icon, encoding, active LSP with icon, line/column, file progress

### Dashboard — alpha-nvim

- Custom ASCII art header
- Quick actions: Recent Files, Find File, New File, Find Word, Load Session, Config
- Footer: plugin count, startup time
- Icons on every action

### Notifications

- **noice.nvim:** popup cmdline, notification messages, search count float
- **fidget.nvim:** LSP progress in bottom-right corner

### Icons — nvim-web-devicons

- Material Design Icons everywhere
- Colorful icons per filetype
- Applied to: neo-tree, lualine, telescope, blink, dashboard, which-key, neotest, gitsigns, todo-comments, overseer

## Editor

### nvim-treesitter

- Highlight, indentation, incremental selection
- Auto-install parsers: typescript, tsx, javascript, python, lua, dart, json, yaml, toml, html, css, markdown, markdown_inline, bash, regex, vim, vimdoc
- **nvim-treesitter-textobjects:**
  - `vaf`/`vif` — select function (outer/inner)
  - `vac`/`vic` — select class
  - `]m`/`[m` — jump between functions
  - `]c`/`[c` — jump between classes
  - Swap parameters: `<leader>a` / `<leader>A`

### nvim-autopairs

- Auto-close `()`, `[]`, `{}`, `""`, `''`, `` ` ``
- Integration with blink.cmp
- JSX/TSX rules (don't close `<` in generics context)

### nvim-surround

- `ysiw"` — wrap word with `"`
- `cs"'` — change `"` to `'`
- `ds"` — delete quotes
- HTML/JSX tag support

### Comment.nvim

- `gcc` — toggle line comment
- `gc` in visual — toggle block
- **ts-context-commentstring** for correct JSX/TSX comments

### todo-comments.nvim

- Highlight: TODO, FIXME, HACK, WARN, NOTE, PERF with icons
- Telescope integration: `<leader>ft` to list all TODOs
- Distinct icons and colors per type

### nvim-colorizer

- Inline color preview for CSS/hex/rgb values

## LSP, Completion, Formatting, Linting

### LSP — Native Neovim 0.12

- `vim.lsp.config()` + `vim.lsp.enable()` (no mason-lspconfig needed)
- **mason.nvim** only for installing servers/tools

**Servers:**

| Language | Server |
|---|---|
| TypeScript/JavaScript | ts_ls |
| Python | pyright |
| Lua | lua_ls |
| Dart/Flutter | flutter-tools.nvim (internal dartls) |
| JSON | jsonls (with SchemaStore) |
| HTML/CSS | html, cssls |
| YAML/TOML | yamlls, taplo |
| Markdown | marksman |
| Docker | dockerls, docker_compose_language_service |

### blink.cmp

- Sources: LSP, snippets, path, buffer
- Icons in completion menu (lspkind-style)
- No ghost text
- Rounded borders on popup
- Documentation side panel

### conform.nvim — Formatting

| Language | Formatter |
|---|---|
| TS/JS/JSX/TSX | prettierd |
| Python | black |
| Lua | stylua |
| Dart | dart format (via LSP) |
| JSON/YAML/HTML/CSS/MD | prettierd |

- Format on save (3s timeout)
- Fallback to LSP format if formatter unavailable

### nvim-lint — Linting

| Language | Linter |
|---|---|
| TS/JS | eslint_d |
| Python | ruff |
| Lua | luacheck |
| Markdown | markdownlint |
| Docker | hadolint |

- Lint on save and on insert leave

## Tools

### Telescope

- Pickers: find_files, live_grep, buffers, help_tags, diagnostics, lsp_references, lsp_definitions
- Extensions: fzf-native, ui-select
- Icons in all pickers
- Layout: dropdown for short selections, horizontal for searches

### Neo-tree

- Left sidebar with toggle
- Colorful Material Design icons via nvim-web-devicons
- Git status icons per file
- Sources: filesystem, buffers, git_status (tab switch)
- Auto-follow current file
- Filter: node_modules, .git, __pycache__, .venv

### toggleterm.nvim

- Horizontal split as default
- Vertical split available
- Float available
- Named terminals (multiple independent)
- Lazygit as dedicated float terminal
- Split size: 15 lines (horizontal), 40% (vertical)

### bruno.nvim

- Execute `.bru` files from Neovim
- Environment selection via Telescope
- Formatted output in buffer
- Load on demand (`.bru` files or command)

### docker.nvim

- List containers, images, volumes
- Start/stop/restart containers
- View container logs
- Load on demand (command only)

### Markdown

- **render-markdown.nvim:** inline rendering in buffer (headers, bold, lists, checkboxes, tables, code blocks)
- **markdown-preview.nvim:** browser preview on demand for final visualization

### arrow.nvim

- Bookmark files, quick switch between them
- Load on demand

## Git

### gitsigns.nvim

- Gutter signs: additions, removals, changes with icons
- Inline blame (toggle)
- Hunk preview, stage, reset
- Navigation: `]h`/`[h`

## Debug

### nvim-dap + nvim-dap-ui

**Adapters:**

| Runtime | Adapter |
|---|---|
| Node.js/TS/JS | js-debug-adapter (vscode-js-debug) |
| Python | debugpy |
| Flutter/Dart | flutter-tools.nvim (integrated DAP) |
| React Native | js-debug-adapter (attach to Metro) |

**nvim-dap-ui:**
- Visual layout: watches, scopes, breakpoints, call stack, console, REPL
- Auto-open on debug start, auto-close on end
- **nvim-dap-virtual-text:** inline variable values during debug

## Tests

### neotest

**Adapters:**

| Framework | Adapter |
|---|---|
| Jest | neotest-jest |
| Vitest | neotest-vitest |
| Pytest | neotest-python |
| Dart | neotest-dart |

- Pass/fail icons in gutter per test
- Run: nearest test, file, full suite
- Output in split
- Watch mode (re-run on save)

## Notebooks

### molten.nvim + jupytext

- Execute cells inline in Neovim
- Text/table output in buffer
- Image rendering via WezTerm image protocol
- jupytext syncs `.ipynb` <-> `.py` (notebook always valid for Colab/Jupyter upload)
- Load only on `.ipynb` or `.py` with cell markers

## Sessions

### auto-session

- Auto-save and restore: buffers, splits, cursor, tabs
- One session per project directory
- Auto-restore when opening Neovim in directory with saved session
- Dashboard integration: list recent sessions

## Tasks

### overseer.nvim

- Integrated task runner: scripts, builds, commands per project
- Templates: npm scripts, pytest, flutter, make
- Output in split with status (running, success, fail) and icons
- Neotest integration
- Load on demand (command only)

## Project Detection — `project.lua`

Detects project type by root files, activates only relevant tools:

| File Detected | Type | Activates |
|---|---|---|
| `package.json` | Node.js | ts_ls, eslint_d, prettierd, neotest-jest/vitest |
| `pyproject.toml` / `requirements.txt` | Python | pyright, black, ruff, neotest-python, molten |
| `pubspec.yaml` | Flutter | flutter-tools, dart format, neotest-dart |
| `*.ipynb` in root | Notebook | molten, jupytext |
| `docker-compose.yml` | Docker | dockerls, docker.nvim, hadolint |
| `collection.bru` / bruno folder | Bruno | bruno.nvim |

LSPs are lazy by nature (start only on matching filetype). `project.lua` complements by configuring formatters, linters, and specific tools based on context.

## Keymaps — Centralized in `config/keymaps.lua`

All keymaps (core + plugins) defined in a single file. No plugin defines its own keymaps.

### Leader Groups (with Which-Key icons)

| Prefix | Icon | Group | Examples |
|---|---|---|---|
| `<leader>f` |  | Find | `ff` files, `fg` grep, `fb` buffers, `fh` help, `ft` todos, `fd` diagnostics |
| `<leader>e` |  | Explorer | `ee` toggle, `ef` focus current |
| `<leader>l` |  | LSP | `ld` definition, `lr` references, `ln` rename, `la` action, `lf` format, `li` info |
| `<leader>g` |  | Git | `gg` lazygit, `gb` blame, `gp` preview hunk, `gs` stage, `gr` reset |
| `<leader>d` |  | Debug | `db` breakpoint, `dc` continue, `di` step into, `do` step over, `du` DAP UI |
| `<leader>t` |  | Terminal | `th` horizontal, `tv` vertical, `tf` float |
| `<leader>n` |  | Tests | `nr` nearest, `nf` file, `ns` suite, `no` output, `nw` watch |
| `<leader>r` |  | Run | `rb` bruno run, `re` bruno env, `rs` bruno search, `rt` overseer |
| `<leader>s` |  | Session | `ss` save, `sr` restore, `sd` delete |
| `<leader>b` |  | Buffers | `bd` delete, `bn` next, `bp` prev |
| `<leader>m` |  | Markdown | `mp` preview browser, `mr` render toggle |
| `<leader>o` |  | Notebook | `or` run cell, `oa` run all, `on` next, `op` prev |
| `<leader>k` |  | Docker | `kl` containers, `ks` start, `kx` stop, `kg` logs |

### Non-leader Keymaps

- `H`/`L` — previous/next buffer
- `]h`/`[h` — next/prev git hunk
- `]d`/`[d` — next/prev diagnostic
- `]m`/`[m` — next/prev function
- `<C-h/j/k/l>` — navigate splits
- `<C-Up/Down>` — resize splits
- `<Esc>` — clear search highlight

### Which-Key

- Popup with all shortcuts on `<leader>` press
- Icons per group
- Clear descriptions on every keymap
- Short delay (300ms)

## Lazy Loading Strategy

All plugins managed by **lazy.nvim** with aggressive lazy loading:

- **By filetype (`ft`):** LSP servers, treesitter, molten, flutter-tools, bruno
- **By event (`event`):** autopairs, surround, gitsigns, comment, colorizer (on `BufReadPost`/`InsertEnter`)
- **By command (`cmd`):** lazygit, docker, overseer, markdown-preview, neo-tree
- **By keymap (`keys`):** telescope, DAP, neotest, arrow, bruno
- **Immediate:** colorscheme, lualine, noice, dashboard, which-key

## Plugin Count

~45 plugins total (including dependencies), all lazy-loaded for fast startup.
