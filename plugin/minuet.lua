-- LLM code completion (minuet) via blink.cmp, backed by the Groq API
--
-- Completions are requested on demand with <A-y> in insert mode (see
-- plugin/blink-cmp.lua) rather than as-you-type, to stay within Groq's
-- free-tier rate limits. Requires GROQ_API_KEY (see lua/config/env.lua).

local ok, minuet = pcall(require, 'minuet')
if not ok then return end

minuet.setup({
  provider = 'openai_compatible',
  n_completions = 1,
  context_window = 4096,
  -- Generous throttle/debounce in case the source is ever enabled as-you-type
  throttle = 2000,
  debounce = 800,
  request_timeout = 5,

  provider_options = {
    openai_compatible = {
      name = 'Groq',
      end_point = 'https://api.groq.com/openai/v1/chat/completions',
      api_key = 'GROQ_API_KEY',
      model = 'qwen/qwen3.6-27b',
      optional = {
        max_tokens = 256,
        top_p = 0.9,
      },
    },
  },
})
