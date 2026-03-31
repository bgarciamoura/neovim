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
