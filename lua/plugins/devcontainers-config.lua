return {
	-- Suporte a desenvolvimetno dentro de containers
	{
		"jamestthompson3/nvim-remote-containers",
		lazy = true,
		cmd = {
			"RemoteContainersStart",
			"RemoteContainersStop",
			"RemoteContainersAttach",
		},
		config = function()
			require("remote-containers").setup({
				-- Diretório onde armazenar os containers
				containers_store_path = vim.fn.expand("~/.local/share/remote-containers"),

				-- Define extensões padrão para instalar em todos os containers
				default_extensions = {
					"ms-vscode.vscode-typescript-next",
					"Angular.ng-template",
					"dbaeumer.vscode-eslint",
					"esbenp.prettier-vscode",
					"formulahendry.auto-rename-tag",
					"github.copilot",
					"editorconfig.editorconfig",
				},

				-- Configurações específicas para diferentes projetos
				container_config_overrides = {
					-- Exemplo para um projeto Angular
					["angular-projects"] = {
						container_name = "angular-dev",
						image = "mcr.microsoft.com/vscode/devcontainers/typescript-node:0-18",
						additionalExtensions = {
							"johnpapa.Angular2",
							"cyrilletuzi.angular-schematics",
						},
					},

					-- Exemplo para projetos NestJS
					["nestjs-projects"] = {
						container_name = "nestjs-dev",
						image = "mcr.microsoft.com/vscode/devcontainers/typescript-node:0-18",
						additionalExtensions = {
							"ashinzekene.nestjs",
						},
					},

					-- Exemplo para projetos React/NextJS
					["react-projects"] = {
						container_name = "react-dev",
						image = "mcr.microsoft.com/vscode/devcontainers/typescript-node:0-18",
						additionalExtensions = {
							"dsznajder.es7-react-js-snippets",
						},
					},

					-- Exemplo para projetos Golang
					["golang-projects"] = {
						container_name = "golang-dev",
						image = "mcr.microsoft.com/vscode/devcontainers/go:0-1",
					},

					-- Exemplo para projetos Rust
					["rust-projects"] = {
						container_name = "rust-dev",
						image = "mcr.microsoft.com/vscode/devcontainers/rust:0-1-buster",
					},
				},
			})
		end,
	},

	-- Plugin alternativo para DevContainers (caso o anterior não funcione bem)
	{
		"esensar/nvim-dev-container",
		lazy = true,
		cmd = {
			"DevcontainerBuild",
			"DevcontainerImageRun",
			"DevcontainerBuildAndRun",
			"DevcontainerBuildAndRebuildRun",
			"DevcontainerComposeUp",
			"DevcontainerComposeDown",
			"DevcontainerComposeRm",
			"DevcontainerStartAttached",
			"DevcontainerStartDetached",
			"DevcontainerStopActive",
			"DevcontainerStopAllActive",
			"DevcontainerAttachActive",
			"DevcontainerExec",
			"DevcontainerExecuteCommand",
			"DevcontainerOpenExplorer",
		},
		config = function()
			require("devcontainer").setup({
				-- Defina as configurações apenas quando o plugin for carregado (lazy)

				-- Configurações gerais
				config_search_start = function()
					return vim.fn.getcwd()
				end,

				-- Integração com terminal
				terminal_handler = function(command)
					-- Usar toggleterm se disponível
					local toggleterm_ok, _ = pcall(require, "toggleterm")
					if toggleterm_ok then
						require("toggleterm").exec(command)
					else
						vim.cmd("terminal " .. command)
					end
				end,

				-- Configurações Docker automaticamente detectadas do arquivo devcontainer.json
				-- Também é possível especificar configurações personalizadas por diretório
				workspace_folder_provider = function()
					return vim.fn.getcwd()
				end,

				-- Trate automaticamente configurações como extensões
				-- Isso irá analisar extensões do devcontainer.json e instalar suas contrapartes Neovim
				extension_install_mappings = {
					-- Mapeamento de extensões VS Code para plugins Neovim
					["ms-vscode.vscode-typescript-next"] = { "neovim/nvim-lspconfig" },
					["angular.ng-template"] = { "jpcrs/angular.nvim" },
					["dbaeumer.vscode-eslint"] = { "mfussenegger/nvim-lint" },
					["esbenp.prettier-vscode"] = { "MunifTanjim/prettier.nvim" },
					["rust-lang.rust-analyzer"] = { "simrat39/rust-tools.nvim" },
					["golang.go"] = { "ray-x/go.nvim" },
					["github.copilot"] = { "github/copilot.vim" },
				},
			})
		end,
	},

	-- Suporte aprimorado para Docker (Dockerfiles, docker-compose)
	{
		"dgrbrady/nvim-docker",
		lazy = true,
		cmd = { "DockerRun", "DockerComposeUp", "DockerAttach", "DockerImages", "DockerContainers" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("docker").setup({
				-- Configurações do plugin Docker
				attach = {
					-- Estratégia de anexação (pode ser 'tmux' ou 'toggleterm')
					strategy = "toggleterm",
				},
			})
		end,
	},
}
