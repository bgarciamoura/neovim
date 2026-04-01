return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    auto_restore = false,
    auto_save = true,
    auto_create = true,
    suppressed_dirs = { "~/", "~/Downloads", "/" },
    bypass_save_filetypes = { "alpha", "neo-tree" },
    post_restore_cmds = {
      function()
        -- Re-edit all listed buffers so treesitter/LSP attach properly
        vim.defer_fn(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
              local name = vim.api.nvim_buf_get_name(buf)
              if name ~= "" and vim.fn.filereadable(name) == 1 then
                vim.api.nvim_buf_call(buf, function()
                  vim.cmd("silent! edit")
                end)
              end
            end
          end
        end, 100)
      end,
    },
  },
}
