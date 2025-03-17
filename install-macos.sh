#!/bin/bash
# install-macos.sh - Módulo específico para instalação no macOS
# Este arquivo é chamado pelo script principal install-neovim.sh

# Importar utilitários comuns se não estiverem definidos
if [[ -z "$UTILS_IMPORTED" ]]; then
  source "./install-utils.sh"
fi

# Função principal para instalação do Neovim no macOS
install_neovim_macos() {
  print_message "$BLUE" "==== Instalando Neovim no macOS ===="

  # Verificar versões atuais e disponíveis
  check_neovim_versions

  # Verificar se Neovim já está instalado
  if command_exists nvim; then
    if confirm "Deseja reinstalar/atualizar o Neovim para a versão de desenvolvimento mais recente?"; then
      print_message "$YELLOW" "Prosseguindo com a reinstalação/atualização..."
    else
      print_message "$YELLOW" "Mantendo a instalação atual do Neovim."
      return 0
    fi
  fi

  # Verificar e instalar Homebrew
  install_homebrew

  # Instalar Neovim usando Homebrew (sempre versão nightly)
  print_message "$YELLOW" "Instalando Neovim (versão nightly)..."

  # Remover instalação anterior se existir
  if brew list neovim &>/dev/null; then
    print_message "$YELLOW" "Removendo instalação anterior do Neovim..."
    brew uninstall neovim
  fi

  # Instalar versão nightly
  brew install --HEAD neovim

  # Verificar a instalação do Neovim
  if command_exists nvim; then
    print_message "$GREEN" "✅ Neovim (versão nightly) instalado com sucesso: $(nvim --version | head -n 1)"
  else
    print_message "$RED" "❌ Falha ao instalar Neovim nightly. Tentando novamente..."
    brew install --HEAD neovim

    if command_exists nvim; then
      print_message "$GREEN" "✅ Neovim (versão nightly) instalado com sucesso na segunda tentativa: $(nvim --version | head -n 1)"
    else
      print_message "$RED" "❌ Falha ao instalar Neovim. Por favor, instale manualmente."
      return 1
    fi
  fi

  # Instalar dependências adicionais
  install_macos_dependencies

  # Configurar Python para Neovim
  configure_python_for_neovim

  # Perguntar sobre instalações adicionais
  if confirm "Deseja configurar ferramentas de desenvolvimento adicionais?"; then
    install_dev_tools
  fi

  print_message "$GREEN" "✅ Neovim foi instalado com sucesso no macOS!"
  print_message "$GREEN" "Para verificar a instalação, execute: nvim --version"

  return 0
}

# Função para instalar o Homebrew
install_homebrew() {
  # Verificar se o Homebrew está instalado
  if ! command_exists brew; then
    print_message "$YELLOW" "Homebrew não encontrado. Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Adicionar Homebrew ao PATH (dependendo da arquitetura e shell)
    if [[ $(uname -m) == "arm64" ]]; then
      # Apple Silicon (M1/M2)
      HOMEBREW_PREFIX="/opt/homebrew"
    else
      # Intel
      HOMEBREW_PREFIX="/usr/local"
    fi

    # Adicionar ao path do ZSH
    mkdir -p ~/.config/zsh
    if ! grep -q 'eval "$('$HOMEBREW_PREFIX'/bin/brew shellenv)"' ~/.config/zsh/.zshrc 2>/dev/null; then
      echo 'eval "$('$HOMEBREW_PREFIX'/bin/brew shellenv)"' >>~/.config/zsh/.zshrc
    fi

    # Carregar Homebrew para uso imediato
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

    print_message "$GREEN" "✅ Homebrew instalado com sucesso!"
  else
    print_message "$GREEN" "✅ Homebrew já está instalado."
    brew update
  fi
}

# Função para instalar dependências do macOS
install_macos_dependencies() {
  print_message "$YELLOW" "Instalando dependências comuns para desenvolvimento no macOS..."

  # Lista de pacotes essenciais
  local essential_packages=(
    git
    curl
    wget
    ripgrep
    fd
    python3
    fzf
    tmux
    jq
    tree
    bat
    exa
  )

  # Instalar pacotes essenciais
  for package in "${essential_packages[@]}"; do
    install_brew_package "$package"
  done

  # Configurar alias úteis no ZSH
  configure_macos_aliases
}

# Configurar aliases úteis para macOS no ZSH
configure_macos_aliases() {
  print_message "$YELLOW" "Configurando aliases úteis para macOS..."

  local zshrc_file="$HOME/.config/zsh/.zshrc"

  # Verificar se os aliases já estão configurados
  if [[ -f "$zshrc_file" ]] && grep -q "# macOS specific aliases" "$zshrc_file"; then
    print_message "$GREEN" "✅ Aliases do macOS já configurados."
    return 0
  fi

  # Adicionar aliases específicos do macOS
  cat >>"$zshrc_file" <<'EOT'

# macOS specific aliases
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
# Melhores alternativas para comandos padrão
if command -v exa &> /dev/null; then
  alias ls="exa --icons --group-directories-first"
  alias ll="exa --icons --group-directories-first -la"
  alias la="exa --icons --group-directories-first -a"
  alias lt="exa --icons --group-directories-first -T"
  alias l="exa --icons --group-directories-first -l"
fi
if command -v bat &> /dev/null; then
  alias cat="bat --style=plain"
fi
if command -v fd &> /dev/null; then
  alias find="fd"
fi
if command -v rg &> /dev/null; then
  alias grep="rg"
fi
EOT

  print_message "$GREEN" "✅ Aliases do macOS configurados com sucesso."
}

# Configurar suporte a Python para Neovim
configure_python_for_neovim() {
  print_message "$YELLOW" "Configurando suporte Python para Neovim..."
  # Criar ambiente virtual para Neovim
  NVIM_VENV_PATH="$HOME/.config/nvim-venv"

  # Verificar se já existe, se não, criar
  if [ ! -d "$NVIM_VENV_PATH" ]; then
    print_message "$YELLOW" "Criando ambiente virtual para Neovim..."
    python3 -m venv "$NVIM_VENV_PATH"
  fi

  # Ativar ambiente virtual
  source "$NVIM_VENV_PATH/bin/activate"

  # Atualizar pip
  pip install --upgrade pip

  # Instalar pynvim no ambiente virtual
  pip install pynvim

  # Desativar ambiente virtual
  deactivate

  print_message "$GREEN" "✅ Suporte Python configurado para Neovim."
}

# Instalar ferramentas adicionais de desenvolvimento
install_dev_tools() {
  # Instalar e configurar ZSH se ainda não feito
  if ! command_exists zsh; then
    install_zsh
  else
    configure_zsh
  fi

  # Instalar Starship prompt se o usuário quiser
  if confirm "Deseja instalar o Starship prompt?"; then
    install_starship
  fi

  # Instalar MISE (gerenciador de versões)
  if confirm "Deseja instalar MISE para gerenciar versões de Node.js, Python, etc.?"; then
    install_mise

    # Instalar Node.js via MISE
    if confirm "Deseja instalar Node.js LTS via MISE?"; then
      install_nodejs_mise

      # Instalar PNPM
      if confirm "Deseja instalar PNPM?"; then
        install_pnpm
      fi

      # Instalar Angular CLI
      if confirm "Deseja instalar Angular CLI?"; then
        install_angular_cli
      fi
    fi
  fi

  # Ferramentas adicionais para desenvolvimento de UI
  if confirm "Deseja instalar ferramentas adicionais para desenvolvimento web/UI?"; then
    brew install --cask figma
    brew install --cask visual-studio-code
    brew install --cask iterm2
  fi

  # Ferramentas para Git
  if confirm "Deseja instalar ferramentas avançadas para Git?"; then
    brew install lazygit
    brew install gh
    brew install git-delta
  fi
}

# Instalar Starship prompt
install_starship() {
  print_message "$YELLOW" "Instalando Starship prompt..."

  if command_exists starship; then
    print_message "$GREEN" "✅ Starship já está instalado."
    return 0
  fi

  # Instalar via Homebrew
  brew install starship

  # Verificar instalação
  if command_exists starship; then
    print_message "$GREEN" "✅ Starship instalado com sucesso."

    # Configurar Starship
    mkdir -p ~/.config/starship

    # Copiar configuração se existir
    if [ -f "./starship/starship.toml" ]; then
      print_message "$YELLOW" "Copiando configuração Starship..."
      cp ./starship/starship.toml ~/.config/starship/
    else
      # Criar configuração básica
      print_message "$YELLOW" "Criando configuração básica do Starship..."
      cat >~/.config/starship/starship.toml <<'EOT'
# Configuração básica do Starship

# Espera entre comandos antes de atualizar o prompt (em ms)
command_timeout = 1000

# Formato do prompt
format = """
[╭─ ](bold blue)$directory$git_branch$git_status$nodejs$python$rust$golang
[╰─](bold blue)$character"""

# Caractere do prompt
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

# Diretório atual
[directory]
style = "bold cyan"
truncation_length = 3
truncation_symbol = "…/"

# Git
[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold yellow"

# Linguagens
[nodejs]
symbol = " "
style = "bold green"

[python]
symbol = " "
style = "bold blue"

[rust]
symbol = " "
style = "bold red"

[golang]
symbol = " "
style = "bold cyan"
EOT
    fi

    # Adicionar inicialização ao .zshrc
    local zshrc_file="$HOME/.config/zsh/.zshrc"
    if ! grep -q "starship init" "$zshrc_file"; then
      echo 'eval "$(starship init zsh)"' >>"$zshrc_file"
    fi

    print_message "$GREEN" "✅ Starship configurado com sucesso."
  else
    print_message "$RED" "❌ Falha ao instalar Starship."
  fi
}

# Exportar funções para uso no script principal
export -f install_neovim_macos
export -f install_homebrew
export -f install_macos_dependencies
export -f configure_macos_aliases
export -f configure_python_for_neovim
export -f install_dev_tools
export -f install_starship
