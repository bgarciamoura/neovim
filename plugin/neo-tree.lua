-- Neo-tree file explorer

local ok, neotree = pcall(require, 'neo-tree')
if not ok then return end

neotree.setup({
  close_if_last_window = true,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = true,

  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      with_expanders = true,
      expander_collapsed = '',
      expander_expanded = '',
    },
    icon = {
      folder_closed = '󰉋',
      folder_open = '󰝰',
      folder_empty = '󰉖',
    },
    modified = {
      symbol = '●',
    },
    git_status = {
      symbols = {
        added     = '',
        modified  = '',
        deleted   = '',
        renamed   = '',
        untracked = '',
        ignored   = '',
        unstaged  = '󰄱',
        staged    = '',
        conflict  = '',
      },
    },
  },

  window = {
    position = 'left',
    width = 35,
    mappings = {
      ['l'] = 'open',
      ['h'] = 'close_node',
      ['<CR>'] = 'open',
      ['<C-v>'] = 'open_vsplit',
      ['<C-x>'] = 'open_split',
      ['a'] = { 'add', config = { show_path = 'relative' } },
      ['d'] = 'delete',
      ['r'] = 'rename',
      ['c'] = 'copy',
      ['m'] = 'move',
      ['q'] = 'close_window',
      ['R'] = 'refresh',
      ['?'] = 'show_help',
    },
  },

  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        'node_modules',
        '.git',
        '__pycache__',
        '.venv',
      },
    },
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
  },

  buffers = {
    follow_current_file = { enabled = true },
  },
})

-- Keymaps
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>E', '<Cmd>Neotree reveal<CR>', { desc = 'Reveal file in explorer' })
