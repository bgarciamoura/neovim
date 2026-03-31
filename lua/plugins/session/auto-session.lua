return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    auto_restore = true,
    auto_save = true,
    auto_create = true,
    suppressed_dirs = { "~/", "~/Downloads", "/" },
    bypass_save_filetypes = { "alpha", "neo-tree" },
    post_restore_cmds = {
      function()
        -- Re-trigger BufReadPost on all buffers so treesitter activates highlight
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
            vim.api.nvim_exec_autocmds("BufReadPost", { buffer = buf })
          end
        end
      end,
    },
  },
}
