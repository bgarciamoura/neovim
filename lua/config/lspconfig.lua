local lspconfig = require("lspconfig")
local vim = vim

-- Função para anexar configurações extras ao LSP
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Ir para definição
  -- voltar da definição
  vim.keymap.set("n", "<C-o>", function()
    vim.api.nvim_command("normal! <C-o>")
  end, opts)

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                -- Mostrar documentação
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- Renomear símbolo
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Sugestão de correções
end

-- Configurar servidores
local servers = { "ts_ls", "eslint", "html", "cssls", "jsonls", "lua_ls", "angularls", "dockerls", "prismals", "nxls" }
for _, server in ipairs(servers) do
  lspconfig[server].setup({
    on_attach = on_attach,
  })
end
