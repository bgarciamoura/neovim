local menu = require('menu')
local vim = vim

local coc_options = {
  {
    name = "Go to Definition",
    cmd = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(coc-definition)', true, true, true), 'n', true)
    end
  },
  {
    name = "Go to Type Definition",
    cmd = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(coc-type-definition)', true, true, true), 'n', true)
    end
  },
  {
    name = "Go to Implementation",
    cmd = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(coc-implementation)', true, true, true), 'n', true)
    end
  },
  {
    name = "Go to References",
    cmd = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(coc-references)', true, true, true), 'n', true)
    end
  },
  {
    name = "Show Documentation",
    cmd = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CMD>lua _G.show_docs()<CR>', true, true, true), 'n', true)
    end
  },
}

-- Menu Options
local menu_options = {
  {
    name = "Format Buffer",
    cmd = function()
      vim.cmd(":Format")
    end
  },
  {
    name = "Symbol Rename",
    cmd = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(coc-rename)', true, true, true), 'n', true)
    end
  },
  {
    name = "Code Action",
    cmd = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(coc-codeaction-cursor)', true, true, true), 'n', true)
    end
  },
  { name = "separator" },
  {
    name = "Coc",
    hl = "Exblue",
    items = coc_options,
  },
  { name = "separator" },

  {
    name = "Edit Config",
    cmd = function()
      vim.cmd "tabnew"
      local conf = vim.fn.stdpath "config"
      vim.cmd("tcd " .. conf .. " | e init.lua")
    end,
    rtxt = "ed",
  },

  {
    name = "Copy Content",
    cmd = "%y+",
    rtxt = "<C-c>",
  },

  {
    name = "Delete Content",
    cmd = "%d",
    rtxt = "dc",
  },

  { name = "separator" },

  -- {
  --   name = "  Open in terminal",
  --   hl = "ExRed",
  --   cmd = function()
  --     local old_buf = require("menu.state").old_data.buf
  --     local old_bufname = vim.api.nvim_buf_get_name(old_buf)
  --     local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")
  --
  --     local cmd = "cd " .. old_buf_dir
  --
  --     -- base46_cache var is an indicator of nvui user!
  --     if vim.g.base46_cache then
  --       require("nvchad.term").new { cmd = cmd, pos = "sp" }
  --     else
  --       vim.cmd "enew"
  --       vim.fn.termopen { vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell }
  --     end
  --   end,
  -- },

  -- { name = "separator" },

  {
    name = "  Color Picker",
    cmd = function()
      require("minty.huefy").open()
    end,
  },
}

-- Neotree Menu Options
local neotree_options = {

  {
    name = "  Color Picker",
    cmd = function()
      require("minty.huefy").open()
    end,
  },
  {
    name = "  Open in terminal",
    hl = "ExRed",
    cmd = function()
      local old_buf = require("menu.state").old_data.buf
      local old_bufname = vim.api.nvim_buf_get_name(old_buf)
      local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

      local cmd = "cd " .. old_buf_dir

      -- base46_cache var is an indicator of nvui user!
      if vim.g.base46_cache then
        require("nvchad.term").new { cmd = cmd, pos = "sp" }
      else
        vim.cmd "enew"
        vim.fn.termopen { vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell }
      end
    end,
  },
  {
    name = "Edit Config",
    cmd = function()
      vim.cmd "tabnew"
      local conf = vim.fn.stdpath "config"
      vim.cmd("tcd " .. conf .. " | e init.lua")
    end,
    rtxt = "ed",
  },
  {
    name = "Copy Content",
    cmd = "%y+",
    rtxt = "<C-c>",
  },
  {
    name = "Delete Content",
    cmd = "%d",
    rtxt = "dc",
  },
}

vim.keymap.set("n", "<leader>mm", function() menu.open("default") end, { noremap = true, silent = true })
vim.keymap.set("n", "<RightMouse>", function()
  local options = vim.bo.ft == "neo-tree" and neotree_options or menu_options
  menu.open(options, { mouse = true })
end, { noremap = true, silent = true })

