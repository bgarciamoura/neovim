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
    lazy = false,
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
      vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
        config = config or {}
        config.border = "rounded"
        return vim.lsp.handlers.hover(err, result, ctx, config)
      end
      vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
        config = config or {}
        config.border = "rounded"
        return vim.lsp.handlers.signature_help(err, result, ctx, config)
      end

      -- ── Helper: disable formatting from LSP (defer to conform.nvim) ────────
      local function on_attach(client, _bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      -- ── Server configurations via vim.lsp.config() ─────────────────────────

      -- TypeScript / JavaScript
      vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        on_attach = on_attach,
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
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
        cmd = { "pyright-langserver", "--stdio" },
        on_attach = on_attach,
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
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
        cmd = { "lua-language-server" },
        on_attach = on_attach,
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
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
        cmd = { "vscode-json-language-server", "--stdio" },
        on_attach = on_attach,
        filetypes = { "json", "jsonc" },
        root_markers = { ".git" },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- YAML (SchemaStore)
      vim.lsp.config("yamlls", {
        cmd = { "yaml-language-server", "--stdio" },
        on_attach = on_attach,
        filetypes = { "yaml", "yaml.docker-compose" },
        root_markers = { ".git" },
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

      -- Simple servers
      local simple_servers = {
        html = { cmd = { "vscode-html-language-server", "--stdio" }, filetypes = { "html", "templ" } },
        cssls = { cmd = { "vscode-css-language-server", "--stdio" }, filetypes = { "css", "scss", "less" } },
        taplo = { cmd = { "taplo", "lsp", "stdio" }, filetypes = { "toml" } },
        marksman = { cmd = { "marksman", "server" }, filetypes = { "markdown", "markdown.mdx" } },
        dockerls = { cmd = { "docker-langserver", "--stdio" }, filetypes = { "dockerfile" } },
        docker_compose_language_service = { cmd = { "docker-compose-langserver", "--stdio" }, filetypes = { "yaml.docker-compose" } },
      }
      for server, cfg in pairs(simple_servers) do
        cfg.on_attach = on_attach
        cfg.root_markers = cfg.root_markers or { ".git" }
        vim.lsp.config(server, cfg)
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
