-- Cursor-style AI editing (Avante)
--
-- Providers (switch with :AvanteSwitchProvider / <leader>as):
--   * groq        — default; Groq API, requires GROQ_API_KEY (lua/config/env.lua)
--   * claude-code — Claude Code via ACP, covered by the Claude Max subscription.
--                   Built-in provider: runs `claude-agent-acp` with the `claude`
--                   CLI found on PATH (npm i -g @zed-industries/claude-agent-acp).
--
-- The native libraries are downloaded by the PackChanged hook in
-- lua/config/plugins.lua (scripts/avante-build.sh).

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

  acp_providers = {
    ['claude-code'] = {
      command = 'claude-agent-acp',
      args = {},
      env = {
        NODE_NO_WARNINGS = '1',
        ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath('claude'),
        -- Ask before running tools/editing files (default is bypassPermissions)
        ACP_PERMISSION_MODE = 'default',
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
