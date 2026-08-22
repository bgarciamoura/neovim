-- HTTP client for .http files (kulala) — call LLM APIs directly and inspect
-- the raw request/response. Variables like {{GROQ_API_KEY}} are resolved
-- from a .env file next to the .http file (or http-client.env.json).
--
-- Example (save as groq.http in your project):
--
--   POST https://api.groq.com/openai/v1/chat/completions
--   Authorization: Bearer {{GROQ_API_KEY}}
--   Content-Type: application/json
--
--   {
--     "model": "qwen/qwen3.6-27b",
--     "temperature": 0.7,
--     "messages": [
--       { "role": "system", "content": "Você é um assistente conciso." },
--       { "role": "user", "content": "Explique o que é few-shot prompting." }
--     ]
--   }

local ok, kulala = pcall(require, 'kulala')
if not ok then return end

vim.filetype.add({
  extension = {
    http = 'http',
    rest = 'http',
  },
})

kulala.setup({
  global_keymaps = false, -- keymaps live in lua/config/keymaps.lua (<leader>ak / <leader>aK)
  ui = {
    display_mode = 'split',
    split_direction = 'vertical',
    default_view = 'body',
    show_icons = 'on_request',
    winbar = true,
  },
})
