-- Side-by-side review of changes, history and conflicts

-- codediff downloads two prebuilt binaries by default. The diff library is
-- built from source instead (see build_hooks in lua/config/plugins.lua), and
-- without the watcher it falls back to polling for changes.
vim.env.VSCODE_DIFF_NO_AUTO_INSTALL = '1'
vim.env.CODEDIFF_WATCHER_NO_AUTO_INSTALL = '1'

local ok, codediff = pcall(require, 'codediff')
if not ok then return end

codediff.setup({
  explorer = {
    width = 50,
    view_mode = 'tree',
    auto_open_on_cursor = true,
    line_stats = { enabled = true },
  },
  diff = {
    -- Compact mode (gc) can hit neovim/neovim#40290, which is still present in
    -- 0.12.2 and crashes on wiped diff buffers, so it stays opt-in.
    compact = false,
    compact_context_lines = 8,
    compact_sync_folds = true,
  },
})
