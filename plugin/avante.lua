-- Cursor-style AI editing (Avante) backed by the Groq API
--
-- Requires GROQ_API_KEY in the environment (see lua/config/env.lua).
-- The native tokenizer library is downloaded by the PackChanged hook in
-- lua/config/plugins.lua (`make BUILD_FROM_SOURCE=false`).

local ok, avante = pcall(require, 'avante')
if not ok then return end

-- Avante recommends a global statusline for its sidebar layout
vim.o.laststatus = 3

avante.setup({
  provider = 'groq',
  -- Auto suggestions would burn through Groq's free-tier rate limit;
  -- minuet (<A-y>) covers on-demand completion instead.
  auto_suggestions_provider = 'groq',

  providers = {
    groq = {
      __inherited_from = 'openai',
      api_key_name = 'GROQ_API_KEY',
      endpoint = 'https://api.groq.com/openai/v1/',
      model = 'qwen/qwen3.6-27b',
      timeout = 30000,
      extra_request_body = {
        temperature = 0.3,
        max_tokens = 8192,
      },
    },
  },

  behaviour = {
    auto_suggestions = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = false, -- <leader>a* keymaps are defined in lua/config/keymaps.lua
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
  },

  windows = {
    position = 'right',
    width = 40,
    sidebar_header = { rounded = true },
  },
})
