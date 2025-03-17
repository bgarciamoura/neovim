#!/bin/bash
# install-utils.sh - Funções utilitárias compartilhadas entre os módulos de instalação

# Marcar o módulo como importado para evitar importações duplicadas
export UTILS_IMPORTED=1

# Cores para melhor legibilidade
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export MAGENTA='\033[0;35m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

# Versões padrão para software
export NODE_VERSION="lts"
export PNPM_VERSION="latest"
export ANGULAR_CLI_VERSION="latest"

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
    [Ss]*) return 0 ;; # Retorna sucesso (0) para "Sim"
    [Nn]*) return 1 ;; # Retorna falha (1) para "Não"
    "") return 0 ;;    # Retorna sucesso para Enter (resposta padrão é sim)
    *) echo "Por favor, responda com s ou n." ;;
    esac
  done
}

# Função para verificar se um comando existe
command_exists() {
  command -v "$1" &>/dev/null
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

# Função para detectar o sistema operacional
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if grep -qi "ubuntu" /etc/os-release 2>/dev/null || grep -qi "debian" /etc/os-release 2>/dev/null; then
      echo "ubuntu"
    else
      echo "linux"
    fi
  elif [[ -n "$WINDIR" || -n "$windir" ]]; then
    echo "windows"
  elif [[ "$(uname -r)" == *"WSL"* || "$(uname -r)" == *"microsoft"* ]]; then
    echo "wsl"
  else
    echo "unknown"
  fi
}

# Função para instalar MISE (gerenciador de versões)
install_mise() {
  print_message "$BLUE" "==== Instalando MISE - Gerenciador de Versões ===="

  if command_exists mise; then
    print_message "$GREEN" "✅ MISE já está instalado."
    mise --version
    return 0
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    print_message "$YELLOW" "Instalando MISE via Homebrew..."
    brew install mise
  else
    # Linux
    print_message "$YELLOW" "Instalando MISE via curl..."
    curl https://mise.jdx.dev/install.sh | sh

    # Adicionar mise ao ambiente ZSH
    zsh_config_dir="$HOME/.config/zsh"
    mkdir -p "$zsh_config_dir"

    if [[ -f "$zsh_config_dir/.zshrc" ]]; then
      if ! grep -q "mise activate" "$zsh_config_dir/.zshrc"; then
        echo 'eval "$(~/.local/bin/mise activate zsh)"' >>"$zsh_config_dir/.zshrc"
      fi
    else
      echo 'eval "$(~/.local/bin/mise activate zsh)"' >>"$zsh_config_dir/.zshrc"
    fi
  fi

  # Verificar instalação
  if command_exists mise; then
    print_message "$GREEN" "✅ MISE instalado com sucesso."
    mise --version
  else
    print_message "$RED" "❌ Falha ao instalar MISE. Verificando se está disponível no PATH..."
    export PATH="$HOME/.local/bin:$PATH"
    if command_exists mise; then
      print_message "$GREEN" "✅ MISE encontrado em ~/.local/bin."
      mise --version
    else
      print_message "$RED" "❌ MISE não pôde ser encontrado. Continuando sem MISE."
      return 1
    fi
  fi

  return 0
}

# Função para instalar Node.js via MISE
install_nodejs_mise() {
  print_message "$BLUE" "==== Instalando Node.js via MISE ===="

  if ! command_exists mise; then
    print_message "$RED" "MISE não está instalado. Instalando MISE primeiro..."
    install_mise
  fi

  # Verificar se Node.js já está instalado via MISE
  if mise ls --installed | grep -q "nodejs"; then
    print_message "$GREEN" "✅ Node.js já está instalado via MISE."
    local current_node_version=$(mise x nodejs -- node --version)
    print_message "$YELLOW" "Versão atual: $current_node_version"

    # Verificar se é versão LTS (número par na versão principal)
    if [[ $current_node_version =~ v([0-9]+) ]]; then
      local major_version="${BASH_REMATCH[1]}"
      if ((major_version % 2 != 0)); then
        print_message "$YELLOW" "Você está usando uma versão não-LTS do Node.js (número ímpar)."
        if confirm "Deseja mudar para a versão LTS mais recente?"; then
          print_message "$YELLOW" "Instalando Node.js LTS via MISE..."
          mise install nodejs@lts
          mise use nodejs@lts
          print_message "$GREEN" "✅ Node.js LTS instalado com sucesso."
          mise x nodejs -- node --version
        fi
      fi
    fi
    return 0
  fi

  # Instalar Node.js (garantindo que seja LTS)
  print_message "$YELLOW" "Instalando Node.js LTS via MISE..."
  mise install nodejs@lts
  mise use nodejs@lts

  # Verificar instalação
  if mise x nodejs -- node --version &>/dev/null; then
    print_message "$GREEN" "✅ Node.js LTS instalado com sucesso via MISE."
    mise x nodejs -- node --version

    # Configurar MISE para sempre usar LTS por padrão
    mkdir -p ~/.config/mise
    if [[ -f ~/.config/mise/config.toml ]]; then
      # Verifica se a seção [tools] já existe
      if grep -q "\[tools\]" ~/.config/mise/config.toml; then
        # Verifica se nodejs já está configurado
        if grep -q "nodejs" ~/.config/mise/config.toml; then
          # Atualiza a configuração existente
          sed -i'.bak' 's/nodejs = ".*"/nodejs = "lts"/' ~/.config/mise/config.toml
        else
          # Adiciona nodejs à seção tools existente
          sed -i'.bak' '/\[tools\]/a\nodejs = "lts"' ~/.config/mise/config.toml
        fi
      else
        # Adiciona a seção [tools] e nodejs
        echo -e "\n[tools]\nnodejs = \"lts\"" >>~/.config/mise/config.toml
      fi
    else
      # Cria um novo arquivo config.toml
      echo -e "[tools]\nnodejs = \"lts\"" >~/.config/mise/config.toml
    fi
    print_message "$GREEN" "✅ MISE configurado para usar Node.js LTS globalmente."
  else
    print_message "$RED" "❌ Falha ao instalar Node.js via MISE."
    return 1
  fi

  return 0
}

# Função para instalar PNPM
install_pnpm() {
  print_message "$BLUE" "==== Instalando PNPM - Gerenciador de Pacotes ===="

  if command_exists pnpm; then
    print_message "$GREEN" "✅ PNPM já está instalado."
    pnpm --version
    return 0
  fi

  # Verificar se temos Node.js instalado
  if ! command_exists node; then
    print_message "$RED" "❌ Node.js não está instalado. Instalando Node.js primeiro..."
    if confirm "Instalar Node.js via MISE?"; then
      install_nodejs_mise
    else
      print_message "$RED" "❌ Node.js é necessário para instalar PNPM. Instalação abortada."
      return 1
    fi
  fi

  # Instalar PNPM
  print_message "$YELLOW" "Instalando PNPM..."
  if command_exists npm; then
    npm install -g pnpm
  elif command_exists mise && mise ls --installed | grep -q "nodejs"; then
    mise x nodejs -- npm install -g pnpm
  else
    curl -fsSL https://get.pnpm.io/install.sh | sh -
  fi

  # Verificar instalação
  if command_exists pnpm; then
    print_message "$YELLOW" "Configurando ambiente PNPM..."

    # Definir PNPM_HOME e atualizar o PATH antes do setup
    PNPM_HOME="$HOME/.local/share/pnpm"
    export PNPM_HOME
    export PATH="$PNPM_HOME:$PATH"

    # Configurar explicitamente o diretório global para binários
    pnpm config set global-bin-dir "$PNPM_HOME"

    # Executar setup do PNPM
    pnpm setup

    # Persistir a configuração para bash
    if [ -f ~/.bashrc ]; then
      if ! grep -q "PNPM_HOME" ~/.bashrc; then
        echo "export PNPM_HOME=\"$PNPM_HOME\"" >>~/.bashrc
        echo 'export PATH="$PNPM_HOME:$PATH"' >>~/.bashrc
      fi
    fi

    # Persistir a configuração para zsh
    zsh_config_dir="$HOME/.config/zsh"
    if [ -f "$zsh_config_dir/.zshrc" ]; then
      if ! grep -q "PNPM_HOME" "$zsh_config_dir/.zshrc"; then
        echo "export PNPM_HOME=\"$PNPM_HOME\"" >>"$zsh_config_dir/.zshrc"
        echo 'export PATH="$PNPM_HOME:$PATH"' >>"$zsh_config_dir/.zshrc"
      fi
    fi

    print_message "$GREEN" "✅ PNPM instalado e configurado com sucesso."
    pnpm --version
  else
    print_message "$RED" "❌ Falha ao instalar PNPM."
    return 1
  fi

  return 0
}

# Função para instalar Angular CLI
install_angular_cli() {
  print_message "$BLUE" "==== Instalando Angular CLI ===="

  if command_exists ng; then
    print_message "$GREEN" "✅ Angular CLI já está instalado."
    ng version
    return 0
  fi

  # Verificar se temos PNPM instalado
  if ! command_exists pnpm; then
    print_message "$RED" "❌ PNPM não está instalado. Instalando PNPM primeiro..."
    install_pnpm
  fi

  # Instalar Angular CLI
  print_message "$YELLOW" "Instalando Angular CLI via PNPM..."
  pnpm add -g @angular/cli@$ANGULAR_CLI_VERSION

  # Verificar instalação
  if command_exists ng; then
    print_message "$GREEN" "✅ Angular CLI instalado com sucesso."
    ng version
  else
    print_message "$RED" "❌ Falha ao instalar Angular CLI via PNPM. Tentando com NPM..."
    npm install -g @angular/cli@$ANGULAR_CLI_VERSION

    if command_exists ng; then
      print_message "$GREEN" "✅ Angular CLI instalado com sucesso via NPM."
      ng version
    else
      print_message "$RED" "❌ Falha ao instalar Angular CLI."
      return 1
    fi
  fi

  return 0
}

# Função para configurar ZSH
configure_zsh() {
  print_message "$BLUE" "==== Configurando ambiente ZSH ===="

  # Criar diretório de configuração ZSH
  mkdir -p ~/.config/zsh

  # Configurar .zshenv para apontar para ~/.config/zsh
  if [ ! -f ~/.zshenv ] || ! grep -q "ZDOTDIR" ~/.zshenv; then
    print_message "$YELLOW" "Criando .zshenv para apontar para ~/.config/zsh..."
    echo 'export ZDOTDIR="$HOME/.config/zsh"' >~/.zshenv
    print_message "$GREEN" "✅ .zshenv criado com sucesso."
  else
    print_message "$GREEN" "✅ .zshenv já existe e configura ZDOTDIR."
  fi

  # Copiar arquivos de configuração ZSH se existirem
  if [ -f "./zsh/.zshrc" ]; then
    print_message "$YELLOW" "Copiando configuração .zshrc..."
    cp "./zsh/.zshrc" ~/.config/zsh/.zshrc
    print_message "$GREEN" "✅ .zshrc copiado com sucesso."
  else
    # Criar um .zshrc básico se não existir
    if [ ! -f ~/.config/zsh/.zshrc ]; then
      print_message "$YELLOW" "Criando arquivo .zshrc básico..."
      cat >~/.config/zsh/.zshrc <<'EOZSHRC'
# Configuração básica do ZSH
export HISTFILE="$HOME/.config/zsh/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# Aliases básicos
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Path customizado
export PATH="$HOME/.local/bin:$PATH"

# Suporte a Starship se instalado
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Suporte a MISE se instalado
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

# Suporte a PNPM se instalado
if command -v pnpm &> /dev/null; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
fi
EOZSHRC
      print_message "$GREEN" "✅ Arquivo .zshrc básico criado."
    fi
  fi

  if [ -f "./starship/starship.toml" ]; then
    print_message "$YELLOW" "Copiando configuração Starship..."
    mkdir -p ~/.config/starship
    cp ./starship/starship.toml ~/.config/starship/
    print_message "$GREEN" "✅ Configuração Starship copiada."
  fi

  return 0
}

# Função para instalar ZSH
install_zsh() {
  print_message "$BLUE" "==== Instalando ZSH e configurando como shell padrão ===="

  if command_exists zsh; then
    print_message "$GREEN" "✅ ZSH já está instalado."
    zsh --version
  else
    print_message "$YELLOW" "Instalando ZSH..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      brew install zsh
    else
      # Ubuntu/Debian
      sudo apt-get update
      sudo apt-get install -y zsh
    fi

    if command_exists zsh; then
      print_message "$GREEN" "✅ ZSH instalado com sucesso."
      zsh --version
    else
      print_message "$RED" "❌ Falha ao instalar ZSH. Continuando sem ZSH."
      return 1
    fi
  fi

  # Configurar ZSH como shell padrão
  print_message "$YELLOW" "Configurando ZSH como shell padrão..."
  if [[ "$SHELL" != *"zsh"* ]]; then
    if command_exists chsh; then
      ZSH_PATH=$(which zsh)
      print_message "$YELLOW" "Alterando shell padrão para $ZSH_PATH"
      sudo chsh -s "$ZSH_PATH" "$USER"

      if [ $? -eq 0 ]; then
        print_message "$GREEN" "✅ ZSH configurado como shell padrão."
      else
        print_message "$RED" "❌ Falha ao configurar ZSH como shell padrão."
      fi
    else
      print_message "$RED" "❌ Comando chsh não encontrado. Por favor, altere seu shell manualmente para ZSH."
    fi
  else
    print_message "$GREEN" "✅ ZSH já está configurado como shell padrão."
  fi

  # Configurar ambiente ZSH
  configure_zsh

  return 0
}

# Função para verificar dependências básicas
check_basic_dependencies() {
  local missing_deps=()

  for dep in git curl wget; do
    if ! command_exists "$dep"; then
      missing_deps+=("$dep")
    fi
  done

  if [ ${#missing_deps[@]} -gt 0 ]; then
    print_message "$YELLOW" "Dependências básicas faltando: ${missing_deps[*]}"
    print_message "$YELLOW" "Instalando dependências básicas..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      for dep in "${missing_deps[@]}"; do
        install_brew_package "$dep"
      done
    else
      # Ubuntu/Debian
      sudo apt-get update
      for dep in "${missing_deps[@]}"; do
        install_apt_package "$dep"
      done
    fi
  else
    print_message "$GREEN" "✅ Todas as dependências básicas estão instaladas."
  fi
}

# Função para gerar relatório de instalação
generate_installation_report() {
  print_message "$BLUE" "===== Resumo das ferramentas instaladas ====="

  if command_exists nvim; then
    print_message "$GREEN" "✅ Neovim: $(nvim --version | head -n 1)"
  else
    print_message "$RED" "❌ Neovim não foi instalado"
  fi

  if command_exists zsh; then
    print_message "$GREEN" "✅ ZSH: $(zsh --version)"
  else
    print_message "$RED" "❌ ZSH não foi instalado"
  fi

  if command_exists mise; then
    print_message "$GREEN" "✅ MISE: $(mise --version)"
  else
    print_message "$RED" "❌ MISE não foi instalado"
  fi

  if command_exists node; then
    print_message "$GREEN" "✅ Node.js: $(node --version)"
  else
    print_message "$RED" "❌ Node.js não foi instalado"
  fi

  if command_exists pnpm; then
    print_message "$GREEN" "✅ PNPM: $(pnpm --version)"
  else
    print_message "$RED" "❌ PNPM não foi instalado"
  fi

  if command_exists ng; then
    print_message "$GREEN" "✅ Angular CLI: $(ng version | grep 'Angular CLI:' | cut -d: -f2 | tr -d ' ')"
  else
    print_message "$RED" "❌ Angular CLI não foi instalado"
  fi

  print_message "$YELLOW" "Configuração ZSH:"
  if [ -f ~/.zshenv ]; then
    print_message "$GREEN" "✅ .zshenv configurado"
  else
    print_message "$RED" "❌ .zshenv não configurado"
  fi

  if [ -f ~/.config/zsh/.zshrc ]; then
    print_message "$GREEN" "✅ .zshrc configurado"
  else
    print_message "$RED" "❌ .zshrc não configurado"
  fi
}

# Função para verificar a versão atual e disponível do Neovim
check_neovim_versions() {
  print_message "$BLUE" "==== Verificando versões do Neovim ===="

  # Verificar versão atual instalada
  if command_exists nvim; then
    local current_version=$(nvim --version | head -n 1)
    print_message "$GREEN" "Versão atual instalada: $current_version"
  else
    print_message "$YELLOW" "Neovim não está instalado atualmente."
  fi

  # Verificar versão disponível (depende do sistema operacional)
  local os_type=$(detect_os)

  case "$os_type" in
  "macos")
    # Verificar a versão mais recente disponível via Homebrew
    print_message "$YELLOW" "Verificando versão mais recente disponível via Homebrew..."
    if command_exists brew; then
      brew update >/dev/null
      local available_info=$(brew info --json=v1 neovim | grep -o '"stable": "[^"]*"' | head -1)
      if [[ -n "$available_info" ]]; then
        local available_version=$(echo "$available_info" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
        print_message "$GREEN" "Versão estável disponível: $available_version"
      fi
      print_message "$GREEN" "Versão de desenvolvimento (HEAD) será instalada."
    else
      print_message "$YELLOW" "Homebrew não está instalado. Não é possível verificar a versão disponível."
    fi
    ;;
  "ubuntu" | "wsl")
    # Verificar a versão disponível via apt
    print_message "$YELLOW" "Verificando versão disponível via repositório PPA unstable..."
    if command_exists apt; then
      # Adicionar temporariamente o repositório unstable se não existir
      local repo_added=false
      if ! grep -q "^deb.*neovim-ppa/unstable" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        sudo apt-get update >/dev/null
        sudo apt-get install -y software-properties-common >/dev/null
        sudo add-apt-repository -y ppa:neovim-ppa/unstable >/dev/null
        repo_added=true
      fi

      sudo apt-get update >/dev/null
      local available_version=$(apt-cache policy neovim | grep -o 'Candidato: [0-9]\+\.[0-9]\+\.[0-9]\+' | cut -d' ' -f2)

      if [[ -n "$available_version" ]]; then
        print_message "$GREEN" "Versão disponível no repositório unstable: $available_version"
      else
        # Se não conseguir extrair a versão, mostrar uma mensagem mais genérica
        print_message "$GREEN" "Versão de desenvolvimento mais recente será instalada."
      fi

      # Se adicionamos o repositório temporariamente, remover
      if [[ "$repo_added" = true ]]; then
        sudo add-apt-repository --remove -y ppa:neovim-ppa/unstable >/dev/null
        sudo apt-get update >/dev/null
      fi
    else
      print_message "$YELLOW" "APT não está disponível. Não é possível verificar a versão mais recente."
    fi
    ;;
  *)
    print_message "$YELLOW" "Não é possível verificar a versão disponível para este sistema operacional."
    ;;
  esac
}

# Exportar funções para uso nos outros scripts
export -f print_message
export -f confirm
export -f command_exists
export -f install_npm_package
export -f install_apt_package
export -f install_brew_package
export -f install_pip_package
export -f detect_os
export -f install_mise
export -f install_nodejs_mise
export -f install_pnpm
export -f install_angular_cli
export -f configure_zsh
export -f install_zsh
export -f check_basic_dependencies
export -f generate_installation_report
export -f check_neovim_versions
