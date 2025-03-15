return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
        alpha = true,
        indent_blankline = {
          enabled = true,
          scope_color = "",
          colored_indent_levels = false
        },
        mason = true,
        noice = true,
        copilot_vim = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        render_markdown = true,
        telescope = {
          enabled = true,
        },
        lsp_trouble = true,
        which_key = true,
      }
    })
  end
}
