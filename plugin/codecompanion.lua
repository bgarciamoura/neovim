-- AI chat / inline assistant (CodeCompanion)
--
-- Two adapters are available (switch inside a chat buffer with `ga`):
--   * groq        — default; Groq API, requires GROQ_API_KEY in the
--                   environment (see lua/config/env.lua and <config>/.env).
--                   Models: https://console.groq.com/docs/models
--   * claude_code — Claude Code via ACP (Agent Client Protocol), covered by
--                   the Claude Max subscription. Requires the `claude` CLI
--                   (logged in) and `npm i -g @zed-industries/claude-agent-acp`.
--                   If it asks for auth, run `claude setup-token` and put
--                   CLAUDE_CODE_OAUTH_TOKEN in <config>/.env.

local ok, codecompanion = pcall(require, 'codecompanion')
if not ok then return end

local GROQ_MODELS = {
  'qwen/qwen3.6-27b', -- Qwen 3.6 (preview) — default for the course
  'openai/gpt-oss-120b', -- strongest general model on Groq
  'openai/gpt-oss-20b', -- fastest
}

codecompanion.setup({
  adapters = {
    acp = {
      -- Claude Code as an agent inside the chat buffer (uses your Claude login)
      claude_code = function()
        return require('codecompanion.adapters').extend('claude_code', {})
      end,
    },
    http = {
      -- Groq exposes an OpenAI-compatible endpoint
      groq = function()
        return require('codecompanion.adapters').extend('openai_compatible', {
          name = 'groq',
          formatted_name = 'Groq',
          env = {
            url = 'https://api.groq.com/openai',
            chat_url = '/v1/chat/completions',
            models_endpoint = '/v1/models',
            api_key = 'GROQ_API_KEY',
          },
          schema = {
            model = {
              default = GROQ_MODELS[1],
              choices = GROQ_MODELS,
            },
            temperature = { default = 0.7 },
            max_tokens = { default = 8192 },
          },
        })
      end,
    },
  },

  interactions = {
    chat = { adapter = 'groq' },
    inline = { adapter = 'groq' },
  },

  display = {
    chat = {
      window = {
        layout = 'vertical',
        width = 0.4,
        border = 'rounded',
      },
      show_settings = true, -- expose model/temperature at the top of the chat buffer
    },
    action_palette = { provider = 'telescope' },
  },

  -- Prompt library tailored to the Generative AI / Prompt Engineering course.
  -- Open with <leader>aa (CodeCompanionActions) or /<short_name> inside a chat.
  prompt_library = {
    ['Avaliar Prompt'] = {
      interaction = 'chat',
      description = 'Critica o prompt selecionado (clareza, papel, formato, few-shot)',
      opts = {
        short_name = 'avaliar',
        modes = { 'v' },
        auto_submit = true,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = 'system',
          content = table.concat({
            'Você é um especialista em Engenharia de Prompts.',
            'Avalie o prompt fornecido pelo usuário segundo: clareza do objetivo,',
            'definição de papel/persona, contexto suficiente, formato de saída esperado,',
            'uso de exemplos (few-shot), restrições e critérios de sucesso.',
            'Aponte problemas concretos e, ao final, entregue uma versão reescrita do prompt.',
            'Responda em português.',
          }, ' '),
        },
        {
          role = 'user',
          content = function(context)
            local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
            return 'Avalie este prompt:\n\n```\n' .. text .. '\n```'
          end,
        },
      },
    },

    ['Explicar Agente Agno'] = {
      interaction = 'chat',
      description = 'Explica o código Agno selecionado (Agent, Team, tools, memória)',
      opts = {
        short_name = 'agno',
        modes = { 'v' },
        auto_submit = true,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = 'system',
          content = table.concat({
            'Você é um engenheiro sênior especialista no framework Agno (Python) para agentes de IA.',
            'Explique o código passo a passo: qual modelo/provider é usado, como o Agent/Team é',
            'configurado, quais tools são registradas, como funciona o fluxo de execução,',
            'memória e instruções. Destaque boas práticas e possíveis melhorias.',
            'Responda em português.',
          }, ' '),
        },
        {
          role = 'user',
          content = function(context)
            local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
            return 'Explique este código Agno:\n\n```' .. context.filetype .. '\n' .. text .. '\n```'
          end,
        },
      },
    },

    ['Gerar System Prompt'] = {
      interaction = 'chat',
      description = 'Gera um system prompt estruturado a partir de uma descrição',
      opts = {
        short_name = 'system',
        modes = { 'n', 'v' },
        auto_submit = false,
      },
      prompts = {
        {
          role = 'system',
          content = table.concat({
            'Você é um especialista em Engenharia de Prompts.',
            'A partir da descrição do usuário, escreva um system prompt completo com as seções:',
            'Papel, Objetivo, Contexto, Regras/Restrições, Formato de saída e Exemplos.',
            'Use markdown. Responda em português.',
          }, ' '),
        },
        {
          role = 'user',
          content = 'Descreva o agente/assistente que você quer criar: ',
        },
      },
    },
  },
})
