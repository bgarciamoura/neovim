return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
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
      sync_install = false,
      auto_install = true,

      highlight = {
        enable = false, -- Neovim 0.12: use native vim.treesitter.start() via autocmd instead
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
      },

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
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
        swap = {
          enable = false, -- disabled: incompatible with Neovim 0.12 (tsrange:start)
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Workaround: nvim-treesitter query predicates use old match API
      -- In Neovim 0.12, match[capture_id] returns a node list, not a single node
      local query = vim.treesitter.query
      local function unwrap_node(match, capture_id)
        local node = match[capture_id]
        if not node then
          return nil
        end
        -- TSNode is userdata; a list of nodes is a table
        if type(node) == "table" then
          node = node[1]
        end
        return node
      end

      pcall(function()
        query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
          local node = unwrap_node(match, pred[2])
          if not node then
            return
          end
          local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
          if ok and text then
            metadata["injection.language"] = text:lower()
          end
        end, { force = true, all = true })
      end)

      -- Native Neovim 0.12 treesitter highlight
      -- Created AFTER nvim-treesitter setup to avoid conflicts
      local ignored = { [""] = true, alpha = true, ["neo-tree"] = true, noice = true, notify = true, ["blink-cmp-menu"] = true, TelescopePrompt = true, TelescopeResults = true }

      vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufWinEnter" }, {
        group = vim.api.nvim_create_augroup("UserTreesitterHL", { clear = true }),
        desc = "Ensure treesitter highlight is active",
        callback = function(event)
          local buf = event.buf
          if vim.bo[buf].buftype ~= "" then
            return
          end

          local ft = vim.bo[buf].filetype

          -- Neo-tree opens files without triggering filetype detection
          -- Manually detect and set filetype when it's empty
          if ft == "" then
            local name = vim.api.nvim_buf_get_name(buf)
            if name ~= "" then
              local detected = vim.filetype.match({ buf = buf, filename = name })
              if detected then
                vim.bo[buf].filetype = detected -- triggers FileType autocmd
              end
            end
            return
          end

          if ignored[ft] then
            return
          end
          pcall(vim.treesitter.start, buf)
        end,
      })
    end,
  },
}
