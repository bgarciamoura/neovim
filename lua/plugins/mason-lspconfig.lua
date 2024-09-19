local masonlsp = require("mason-lspconfig")
local mason = require("mason")

mason.setup {}

masonlsp.setup {
  ensure_installed = { "lua_ls", 'yamlls', 'ts_ls', 'prismals', 'jsonls', 'html', 'eslint', 'emmet_ls', 'dockerls', 'docker_compose_language_service', 'cssls', 'cssmodules_ls', 'css_variables', 'cmake', 'vtsls' },
}


masonlsp.setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {}
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  -- ["lua_ls"] = function ()
  --     -- require("").setup {}
  -- end


}
