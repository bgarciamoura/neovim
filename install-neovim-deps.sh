#!/bin/bash

# Cores para melhor legibilidade
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Lista de LSP servers para instalar
LSP_SERVERS=(
  "typescript-language-server"   # TypeScript/JavaScript
  "vscode-langservers-extracted" # HTML/CSS/JSON
  "lua-language-server"          # Lua
  "bash-language-server"         # Bash
  "pyright"                      # Python
  "yaml-language-server"         # YAML
  "vim-language-server"          # VimScript
  "angular-language-server"      # Angular
  "tailwindcss-language-server"  # Tailwind CSS
  "dockerfile-language-server"   # Dockerfile
  "graphql-language-service-cli" # GraphQL
  "volar"                        # Vue
  "svelte-language-server"       # Svelte
)

# Lista de linters e formatadores para instalar
LINTERS_FORMATTERS=(
  "eslint_d"           # JavaScript/TypeScript linter (mais rápido)
  "prettier"           # Formatador universal
  "stylelint"          # CSS linter
  "markdownlint-cli"   # Markdown linter
  "jsonlint"           # JSON linter
  "yamllint"           # YAML linter
  "shellcheck"         # Bash linter
  "shfmt"              # Bash formatter
  "stylua"             # Lua formatter
  "black"              # Python formatter
  "flake8"             # Python linter
  "hadolint"           # Dockerfile linter
  "docsify-cli"        # Documentação
  "biome"              # JavaScript/TypeScript linter/formatter novo e rápido
)

# Lista de ferramentas extras para desenvolvimento
DEV_TOOLS=(
  "lazygit"            # Git TUI
  "fzf"                # Fuzzy finder
  "jq"                 # JSON processor
  "yq"                 # YAML processor
  "bat"                # Better cat
  "exa"                # Better ls
  "fd"                 # Better find
  "ripgrep"            # Better grep
  "delta"              # Better git diff
)

# Função para imprimir mensagens em cores
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Função para solicitar confirmação do usuário
confirm() {
    local message=$1
    while true; do
        read -p "$message [S/n] " response
        case $response in
            [Ss]* ) return 0;; # Retorna sucesso (0) para "Sim"
            [Nn]* ) return 1;; # Retorna falha (1) para "Não"
            "" ) return 0;;    # Retorna sucesso para Enter (resposta padrão é sim)
            * ) echo "Por favor, responda com s ou n.";;
        esac
    done
}

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" &> /dev/null
}

# Função para instalar um pacote NPM global
install_npm_package() {
    local package=$1
    local package_cmd="${2:-$1}" # Se não for fornecido, usar o nome do pacote
    
    if command_exists "$package_cmd"; then
        print_message "$GREEN" "✅ $package já está instalado: $($package_cmd --version 2>/dev/null || echo 'versão desconhecida')"
        return 0
    fi
    
    print_message "$YELLOW" "Instalando $package..."
    if command_exists pnpm; then
        pnpm config set ignore-build-scripts false -g
        pnpm add -g "$package"
    elif command_exists mise && mise ls --installed | grep -q "nodejs"; then
        mise x nodejs -- npm install -g "$package"
    elif command_exists npm; then
        npm install -g "$package"
    else
        print_message "$RED" "❌ Nem npm nem pnpm estão disponíveis para instalar $package"
        return 1
    fi
    
    if command_exists "$package_cmd"; then
        print_message "$GREEN" "✅ $package instalado com sucesso"
        return 0
    else
        print_message "$RED" "❌ Falha ao instalar $package"
        return 1
    fi
}

# Função para instalar pacotes em sistemas apt (Ubuntu/Debian)
install_apt_package() {
    local package=$1
    local package_cmd="${2:-$1}" # Se não for fornecido, usar o nome do pacote
    
    if command_exists "$package_cmd" || dpkg -l | grep -q "$package"; then
        print_message "$GREEN" "✅ $package já está instalado"
        return 0
    fi
    
    print_message "$YELLOW" "Instalando $package..."
    sudo apt-get update && sudo apt-get install -y "$package"
    
    if command_exists "$package_cmd" || dpkg -l | grep -q "$package"; then
        print_message "$GREEN" "✅ $package instalado com sucesso"
        return 0
    else
        print_message "$RED" "❌ Falha ao instalar $package"
        return 1
    fi
}

# Função para instalar pacotes via Homebrew (macOS)
install_brew_package() {
    local package=$1
    local package_cmd="${2:-$1}" # Se não for fornecido, usar o nome do pacote
    
    if command_exists "$package_cmd" || brew list "$package" &>/dev/null; then
        print_message "$GREEN" "✅ $package já está instalado"
        return 0
    fi
    
    print_message "$YELLOW" "Instalando $package..."
    brew install "$package"
    
    if command_exists "$package_cmd" || brew list "$package" &>/dev/null; then
        print_message "$GREEN" "✅ $package instalado com sucesso"
        return 0
    else
        print_message "$RED" "❌ Falha ao instalar $package"
        return 1
    fi
}

# Função para instalar pacotes Python via pip
install_pip_package() {
    local package=$1
    local package_cmd="${2:-$1}" # Se não for fornecido, usar o nome do pacote
    
    if command_exists "$package_cmd" || pip3 list | grep -i "$package" &>/dev/null; then
        print_message "$GREEN" "✅ $package já está instalado"
        return 0
    fi
    
    print_message "$YELLOW" "Instalando $package..."
    pip3 install --user "$package"
    
    if command_exists "$package_cmd" || pip3 list | grep -i "$package" &>/dev/null; then
        print_message "$GREEN" "✅ $package instalado com sucesso"
        return 0
    else
        print_message "$RED" "❌ Falha ao instalar $package"
        return 1
    fi
}

# Função para instalar LuaRocks packages
install_luarocks_package() {
    local package=$1
    
    if luarocks list | grep -q "$package"; then
        print_message "$GREEN" "✅ $package (Lua) já está instalado"
        return 0
    fi
    
    print_message "$YELLOW" "Instalando $package (Lua)..."
    luarocks install --local "$package"
    
    if luarocks list | grep -q "$package"; then
        print_message "$GREEN" "✅ $package (Lua) instalado com sucesso"
        return 0
    else
        print_message "$RED" "❌ Falha ao instalar $package (Lua)"
        return 1
    fi
}

# Função para instalar o lua-language-server em sistemas baseados em Ubuntu
install_lua_language_server_ubuntu() {
    if command_exists lua-language-server; then
        print_message "$GREEN" "✅ lua-language-server já está instalado"
        return 0
    fi
    
    print_message "$YELLOW" "Instalando lua-language-server a partir do código-fonte..."
    local temp_dir=$(mktemp -d)
    
    sudo apt-get update && sudo apt-get install -y ninja-build
    
    git clone --depth=1 https://github.com/LuaLS/lua-language-server "$temp_dir"
    cd "$temp_dir" || return 1
    ./make.sh
    
    sudo mkdir -p /opt/lua-language-server
    sudo cp -r ./bin/lua-language-server /opt/lua-language-server/
    sudo cp -r ./bin/main.lua /opt/lua-language-server/
    sudo cp -r ./bin/main.lua.c /opt/lua-language-server/
    sudo cp -r ./bin/meta /opt/lua-language-server/
    sudo cp -r ./bin/locale /opt/lua-language-server/
    sudo cp -r ./bin/platform /opt/lua-language-server/
    
    # Criar link simbólico para o executável
    sudo ln -sf /opt/lua-language-server/lua-language-server /usr/local/bin/lua-language-server
    
    cd - || return 1
    rm -rf "$temp_dir"
    
    if command_exists lua-language-server; then
        print_message "$GREEN" "✅ lua-language-server instalado com sucesso"
        return 0
    else
        print_message "$RED" "❌ Falha ao instalar lua-language-server"
        return 1
    fi
}

# Função para instalar o lua-language-server no macOS
install_lua_language_server_macos() {
    if brew list lua-language-server &>/dev/null; then
        print_message "$GREEN" "✅ lua-language-server já está instalado"
        return 0
    fi
    
    print_message "$YELLOW" "Instalando lua-language-server..."
    brew install lua-language-server
    
    if brew list lua-language-server &>/dev/null; then
        print_message "$GREEN" "✅ lua-language-server instalado com sucesso"
        return 0
    else
        print_message "$RED" "❌ Falha ao instalar lua-language-server"
        return 1
    fi
}

# Função para instalar LSP servers
install_lsp_servers() {
    print_message "$BLUE" "==== Instalando servidores LSP ===="
    
    # Instalar lua-language-server dependendo do SO
    if [[ "$OSTYPE" == "darwin"* ]]; then
        install_lua_language_server_macos
    else
        install_lua_language_server_ubuntu
    fi
    
    # Instalar LSP servers via npm/pnpm
    for server in "${LSP_SERVERS[@]}"; do
        case "$server" in
            "lua-language-server")
                # Já instalado acima
                ;;
            *)
                install_npm_package "$server"
                ;;
        esac
    done
}

# Função para instalar linters e formatadores
install_linters_formatters() {
    print_message "$BLUE" "==== Instalando linters e formatadores ===="
    
    for tool in "${LINTERS_FORMATTERS[@]}"; do
        case "$tool" in
            "stylua")
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    install_brew_package "stylua"
                else
                    cargo install stylua
                fi
                ;;
            "black" | "flake8")
                install_pip_package "$tool"
                ;;
            "shellcheck" | "shfmt")
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    install_brew_package "$tool"
                else
                    install_apt_package "$tool"
                fi
                ;;
            *)
                install_npm_package "$tool"
                ;;
        esac
    done
}

# Função para instalar ferramentas de desenvolvimento adicionais
install_dev_tools() {
    print_message "$BLUE" "==== Instalando ferramentas de desenvolvimento adicionais ===="
    
    for tool in "${DEV_TOOLS[@]}"; do
        if [[ "$OSTYPE" == "darwin"* ]]; then
            install_brew_package "$tool"
        else
            case "$tool" in
                "lazygit")
                    if ! command_exists lazygit; then
                        print_message "$YELLOW" "Instalando lazygit..."
                        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                        tar xf lazygit.tar.gz lazygit
                        sudo install lazygit /usr/local/bin
                        rm lazygit lazygit.tar.gz
                    fi
                    ;;
                "bat")
                    install_apt_package "bat" "batcat"
                    if ! command_exists bat && command_exists batcat; then
                        mkdir -p ~/.local/bin
                        ln -sf /usr/bin/batcat ~/.local/bin/bat
                    fi
                    ;;
                "exa")
                    if [[ -f /etc/apt/sources.list ]]; then
                        local ubuntu_version=$(lsb_release -rs)
                        if (( $(echo "$ubuntu_version >= 23.04" | bc -l) )); then
                            # Ubuntu 23.04+ tem o pacote exa
                            install_apt_package "exa"
                        else
                            # Para versões mais antigas, instalar do repositório
                            if ! command_exists exa; then
                                print_message "$YELLOW" "Instalando exa..."
                                wget -qO- https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip > /tmp/exa.zip
                                unzip -q /tmp/exa.zip -d /tmp/exa
                                sudo mv /tmp/exa/bin/exa /usr/local/bin/
                                rm -rf /tmp/exa /tmp/exa.zip
                            fi
                        fi
                    else
                        install_apt_package "exa"
                    fi
                    ;;
                "delta")
                    if ! command_exists delta; then
                        print_message "$YELLOW" "Instalando git-delta..."
                        wget -qO- https://github.com/dandavison/delta/releases/download/0.16.5/delta-0.16.5-x86_64-unknown-linux-gnu.tar.gz > /tmp/delta.tar.gz
                        tar xzf /tmp/delta.tar.gz -C /tmp
                        sudo mv /tmp/delta-*/delta /usr/local/bin/
                        rm -rf /tmp/delta-* /tmp/delta.tar.gz
                    fi
                    ;;
                *)
                    install_apt_package "$tool"
                    ;;
            esac
        fi
    done
}

# Função para configurar o ambiente Neovim
configure_neovim_env() {
    print_message "$BLUE" "==== Configurando ambiente Neovim ===="
    
    # Verificar se já existe uma configuração do Neovim
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        if [ -d "$NVIM_CONFIG_DIR/.git" ]; then
            print_message "$YELLOW" "Configuração existente do Neovim baseada em Git detectada."
            if confirm "Deseja substituir a configuração existente?"; then
                # Fazer backup da configuração existente
                BACKUP_DIR="$HOME/.config/nvim_backup_$(date +%Y%m%d%H%M%S)"
                print_message "$YELLOW" "Fazendo backup da configuração existente para $BACKUP_DIR"
                mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
            else
                print_message "$YELLOW" "Mantendo a configuração existente."
                return 0
            fi
        else
            print_message "$YELLOW" "Diretório de configuração do Neovim existente encontrado."
            if confirm "Deseja substituir a configuração existente?"; then
                # Fazer backup da configuração existente
                BACKUP_DIR="$HOME/.config/nvim_backup_$(date +%Y%m%d%H%M%S)"
                print_message "$YELLOW" "Fazendo backup da configuração existente para $BACKUP_DIR"
                mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
            else
                print_message "$YELLOW" "Mantendo a configuração existente."
                return 0
            fi
        fi
    fi
    
    # Clonar o repositório de configuração do Neovim
    print_message "$YELLOW" "Clonando repositório de configuração do Neovim..."
    git clone https://github.com/bgarciamoura/neovim.git "$NVIM_CONFIG_DIR"
    
    if [ $? -ne 0 ]; then
        print_message "$RED" "❌ Falha ao clonar o repositório. Verifique sua conexão com a internet e o acesso ao GitHub."
        return 1
    fi
    
    print_message "$GREEN" "✅ Repositório de configuração clonado com sucesso para $NVIM_CONFIG_DIR"
    
    # Verificar se há um script de instalação no repositório
    if [ -f "$NVIM_CONFIG_DIR/install.sh" ]; then
        print_message "$YELLOW" "Script de instalação encontrado no repositório"
        if confirm "Deseja executar o script de instalação do repositório?"; then
            chmod +x "$NVIM_CONFIG_DIR/install.sh"
            bash "$NVIM_CONFIG_DIR/install.sh"
        fi
    elif [ -f "$NVIM_CONFIG_DIR/setup.sh" ]; then
        print_message "$YELLOW" "Script de setup encontrado no repositório"
        if confirm "Deseja executar o script de setup do repositório?"; then
            chmod +x "$NVIM_CONFIG_DIR/setup.sh"
            bash "$NVIM_CONFIG_DIR/setup.sh"
        fi
    else
        # Verificar se Treesitter está instalado e configurado
        if command_exists nvim; then
            print_message "$YELLOW" "Instalando plugins e parsers Treesitter..."
            nvim --headless -c "Lazy sync" -c "TSInstall all" -c "q"
        fi
    fi
    
    print_message "$GREEN" "✅ Ambiente Neovim configurado com sucesso"
    print_message "$YELLOW" "Nota: Na primeira vez que abrir o Neovim, os plugins serão instalados automaticamente."
    print_message "$YELLOW" "      Pode ser necessário reiniciar o Neovim após a instalação inicial dos plugins."
}

# Função para detectar o sistema operacional e configurar o ambiente
setup_environment() {
    print_message "$BLUE" "==== Configurando ambiente para Neovim ===="
    
    # Instalar dependências do sistema para compilar extensões
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        print_message "$YELLOW" "Instalando dependências de sistema para macOS..."
        brew install cmake ninja python3 git curl unzip
        
        # Verificar se LuaJIT está instalado
        if ! brew list luajit &>/dev/null; then
            brew install luajit
        fi
        
        # Instalar LuaRocks se não estiver instalado
        if ! command_exists luarocks; then
            brew install luarocks
        fi
    else
        # Ubuntu/Debian
        print_message "$YELLOW" "Instalando dependências de sistema para Ubuntu/Debian..."
        sudo apt-get update
        sudo apt-get install -y \
            build-essential \
            cmake \
            ninja-build \
            python3-dev \
            python3-pip \
            git \
            curl \
            unzip \
            gettext \
            libtool-bin \
            luajit \
            libluajit-5.1-dev
        
        # Instalar LuaRocks se não estiver instalado
        if ! command_exists luarocks; then
            sudo apt-get install -y luarocks
        fi
        
        # Instalar Rust se não estiver instalado (necessário para alguns formatadores)
        if ! command_exists cargo; then
            print_message "$YELLOW" "Instalando Rust..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
        fi
    fi
    
    print_message "$GREEN" "✅ Ambiente de sistema configurado com sucesso"
}

# Função principal
main() {
    print_message "$MAGENTA" "===== Script de Instalação de Dependências do Neovim ====="
    print_message "$CYAN" "Este script instalará LSP servers, linters, formatadores e ferramentas úteis para Neovim."
    
    # Configurar o ambiente primeiro
    setup_environment
    
    # Instalar LSP servers
    if confirm "Deseja instalar servidores LSP?"; then
        install_lsp_servers
    else
        print_message "$YELLOW" "Instalação de servidores LSP ignorada pelo usuário."
    fi
    
    # Instalar linters e formatadores
    if confirm "Deseja instalar linters e formatadores?"; then
        install_linters_formatters
    else
        print_message "$YELLOW" "Instalação de linters e formatadores ignorada pelo usuário."
    fi
    
    # Instalar ferramentas de desenvolvimento adicionais
    if confirm "Deseja instalar ferramentas de desenvolvimento adicionais?"; then
        install_dev_tools
    else
        print_message "$YELLOW" "Instalação de ferramentas adicionais ignorada pelo usuário."
    fi
    
    # Configurar ambiente Neovim
    if confirm "Deseja configurar o ambiente Neovim?"; then
        configure_neovim_env
    else
        print_message "$YELLOW" "Configuração do ambiente Neovim ignorada pelo usuário."
    fi
    
    print_message "$MAGENTA" "===== Instalação de Dependências do Neovim Concluída ====="
}

# Verificar se o script está sendo executado como fonte ou diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Executar a função principal
    main
fi
