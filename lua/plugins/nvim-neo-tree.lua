local neotree = require("neo-tree")


neotree.setup {
  enable_git_status = true,
  close_if_last_window = true,
  indent = {
    expander_collapsed = "",
    expander_expanded = "",
    expander_highlight = "NeoTreeExpander",
  },
  default_component_configs = {
    git_status = {
      symbols = {
        -- Change type
        added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
        deleted   = "✖",
        modified  = "",
        renamed   = "󰁕",
        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
      },
      align = "right",
    },
  },
  filesystem = {
    follow_current_file = {
      enabled = true,

    },
  },
  event_handlers = {
    {
      event = "file_opened",
      handler = function(file_path)
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
  window = {
    width = 30,

  },
}


return neotree
