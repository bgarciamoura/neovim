return {
  -- SchemaStore for JSON/YAML schema validation
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },

  -- Flutter tools (native LSP, no nvim-lspconfig needed)
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "mason-org/mason.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
      lsp = {
        -- flutter-tools manages its own dartls / flutter LSP
        on_attach = function(client, bufnr)
          -- Disable formatting from LSP in favour of conform.nvim
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
    },
  },

  -- Native Neovim 0.12 LSP configuration (no nvim-lspconfig)
  {
    dir = vim.fn.stdpath("config"),
    name = "lsp-config",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      -- ── Diagnostics ────────────────────────────────────────────────────────
      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        virtual_text = {
          prefix = "",
          spacing = 2,
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- ── LSP UI overrides (rounded borders) ─────────────────────────────────
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "rounded" }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = "rounded" }
      )

      -- ── Helper: disable formatting from LSP (defer to conform.nvim) ────────
      local function on_attach(client, _bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      -- ── Server configurations via vim.lsp.config() ─────────────────────────

      -- TypeScript / JavaScript
      vim.lsp.config("ts_ls", {
        on_attach = on_attach,
        filetypes = {
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "javascript",
          "javascriptreact",
          "javascript.jsx",
        },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "literal",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- Pyright
      vim.lsp.config("pyright", {
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      })

      -- Lua
      vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
            telemetry = { enable = false },
          },
        },
      })

      -- JSON (SchemaStore)
      vim.lsp.config("jsonls", {
        on_attach = on_attach,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- YAML (SchemaStore)
      vim.lsp.config("yamlls", {
        on_attach = on_attach,
        settings = {
          yaml = {
            schemaStore = {
              -- disable built-in schemaStore; we use SchemaStore.nvim
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
            validate = true,
            completion = true,
            hover = true,
          },
        },
      })

      -- Simple servers (no extra config required)
      for _, server in ipairs({ "html", "cssls", "taplo", "marksman", "dockerls", "docker_compose_language_service" }) do
        vim.lsp.config(server, { on_attach = on_attach })
      end

      -- ── Enable all servers ──────────────────────────────────────────────────
      vim.lsp.enable({
        "ts_ls",
        "pyright",
        "lua_ls",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
        "taplo",
        "marksman",
        "dockerls",
        "docker_compose_language_service",
      })
    end,
  },
}
