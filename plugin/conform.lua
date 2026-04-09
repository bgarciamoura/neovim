-- Formatting via external tools

local ok, conform = pcall(require, 'conform')
if not ok then return end

-- Use biome if project has biome.json, otherwise prettierd
local function web_formatter()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. '/biome.json') == 1
    or vim.fn.filereadable(root .. '/biome.jsonc') == 1 then
    return { 'biome', stop_after_first = true }
  end
  return { 'prettierd', stop_after_first = true }
end

conform.setup({
  formatters_by_ft = {
    javascript      = web_formatter,
    javascriptreact = web_formatter,
    typescript      = web_formatter,
    typescriptreact = web_formatter,
    json            = web_formatter,
    jsonc           = web_formatter,
    css             = web_formatter,
    yaml            = { 'prettierd', stop_after_first = true },
    html            = { 'prettierd', stop_after_first = true },
    scss            = { 'prettierd', stop_after_first = true },
    markdown        = { 'prettierd', stop_after_first = true },
    graphql         = web_formatter,
    python          = { 'black' },
    lua             = { 'stylua' },
    dart            = { 'dart_format' },
  },
  format_on_save = {
    timeout_ms = 3000,
    lsp_format = 'fallback',
  },
  notify_on_error = true,
})
