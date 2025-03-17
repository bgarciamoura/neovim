#!/bin/bash
# install-ubuntu.sh - Módulo específico para instalação no Ubuntu/Debian
# Este arquivo é chamado pelo script principal install-neovim.sh

# Importar utilitários comuns se não estiverem definidos
if [[ -z "$UTILS_IMPORTED" ]]; then
  source "./install-utils.sh"
fi

# Função principal para instalação do Neovim no Ubuntu/Debian
install_neovim_ubuntu() {
  print_message "$BLUE" "==== Instalando Neovim na versão mais recente no Ubuntu ===="

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

  # Verificar primeiro as dependências básicas
  check_basic_dependencies

  # Verificar repositório PPA do Neovim
  check_and_add_neovim_ppa

  # Instalar Neovim (versão nightly)
  print_message "$YELLOW" "Atualizando repositórios e instalando a versão nightly do Neovim..."
  sudo apt-get update
  sudo apt-get install -y neovim

  # Verificar se é realmente a versão nightly
  if nvim --version | grep -q "NVIM v0.9" || ! nvim --version | grep -q "NVIM"; then
    print_message "$YELLOW" "A versão instalada parece não ser a nightly. Tentando reinstalar forçando a versão mais recente..."
    sudo apt-get install -y --reinstall neovim
  fi

  # Verificar a instalação do Neovim
  if command_exists nvim; then
    print_message "$GREEN" "✅ Neovim instalado com sucesso: $(nvim --version | head -n 1)"
  else
    print_message "$RED" "❌ Falha ao instalar Neovim. Por favor, tente instalar manualmente."
    return 1
  fi

  # Instalar dependências adicionais
  install_ubuntu_dependencies

  # Configurar Python para Neovim
  configure_python_for_neovim

  # Perguntar sobre instalações adicionais
  if confirm "Deseja configurar ferramentas de desenvolvimento adicionais?"; then
    install_dev_tools
  fi

  print_message "$GREEN" "✅ Neovim foi instalado com sucesso no Ubuntu!"
  print_message "$GREEN" "Para verificar a instalação, execute: nvim --version"

  return 0
}

# Função para verificar e adicionar o repositório PPA do Neovim
check_and_add_neovim_ppa() {
  # Verificar se o repositório estável do Neovim já está adicionado
  if ! grep -q "^deb.*neovim-ppa/stable" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
    print_message "$YELLOW" "Adicionando repositório PPA do Neovim..."
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/stable
  else
    print_message "$GREEN" "✅ Repositório PPA do Neovim já está adicionado."
  fi
}

# Função para instalar dependências do Ubuntu
install_ubuntu_dependencies() {
  print_message "$YELLOW" "Instalando dependências comuns para desenvolvimento no Ubuntu..."

  # Lista de pacotes essenciais
  local essential_packages=(
    build-essential
    cmake
    ninja-build
    python3-dev
    python3-pip
    git
    curl
    wget
    unzip
    gettext
    libtool-bin
    ripgrep
    fd-find
  )

  # Instalar pacotes essenciais
  sudo apt-get update
  for package in "${essential_packages[@]}"; do
    install_apt_package "$package"
  done

  # Configurar alias para fd (caso esteja usando fd-find)
  if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    print_message "$YELLOW" "Configurando alias para fd-find..."
    mkdir -p ~/.local/bin
    ln -sf $(which fdfind) ~/.local/bin/fd

    # Adicionar ao PATH do ZSH
    local zshrc_file="$HOME/.config/zsh/.zshrc"
    if ! grep -q '~/.local/bin' "$zshrc_file" 2>/dev/null; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$zshrc_file"
    fi
  fi

  # Instalar outras ferramentas úteis
  if confirm "Deseja instalar ferramentas adicionais como fzf, bat, exa?"; then
    # Instalar fzf
    if ! command_exists fzf; then
      print_message "$YELLOW" "Instalando fzf..."
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --all
    fi

    # Instalar bat (batcat no Ubuntu)
    install_apt_package "bat" "batcat"
    if ! command_exists bat && command_exists batcat; then
      mkdir -p ~/.local/bin
      ln -sf $(which batcat) ~/.local/bin/bat
    fi

    # Tentar instalar exa (verificar versão do Ubuntu)
    if ! command_exists exa; then
      if lsb_release -rs | grep -qE '^(22.04|23.04|23.10)'; then
        # Ubuntu 22.04+ pode ter exa nos repositórios
        install_apt_package "exa"
      else
        # Para versões mais antigas, instalar do GitHub
        print_message "$YELLOW" "Instalando exa a partir do GitHub..."
        local temp_dir=$(mktemp -d)
        wget -qO- "https://github.com/ogham/exa/releases/latest/download/exa-linux-x86_64-musl-v0.10.1.zip" >"$temp_dir/exa.zip"
        unzip -q "$temp_dir/exa.zip" -d "$temp_dir"
        sudo mv "$temp_dir/bin/exa" /usr/local/bin/
        rm -rf "$temp_dir"

        if command_exists exa; then
          print_message "$GREEN" "✅ exa instalado com sucesso."
        else
          print_message "$RED" "❌ Falha ao instalar exa."
        fi
      fi
    fi
  fi

  # Configurar aliases úteis no ZSH
  configure_ubuntu_aliases
}

# Configurar aliases úteis para Ubuntu no ZSH
configure_ubuntu_aliases() {
  print_message "$YELLOW" "Configurando aliases úteis para Ubuntu..."

  local zshrc_file="$HOME/.config/zsh/.zshrc"

  # Verificar se os aliases já estão configurados
  if [[ -f "$zshrc_file" ]] && grep -q "# Ubuntu specific aliases" "$zshrc_file"; then
    print_message "$GREEN" "✅ Aliases do Ubuntu já configurados."
    return 0
  fi

  # Adicionar aliases específicos do Ubuntu
  cat >>"$zshrc_file" <<'EOT'

# Ubuntu specific aliases
alias update="sudo apt update && sudo apt upgrade -y"
alias install="sudo apt install -y"
alias remove="sudo apt remove -y"
alias autoremove="sudo apt autoremove -y"
alias purge="sudo apt purge -y"
alias search="apt search"

# Melhores alternativas para comandos padrão
if command -v exa &> /dev/null; then
  alias ls="exa --icons --group-directories-first"
  alias ll="exa --icons --group-directories-first -la"
  alias la="exa --icons --group-directories-first -a"
  alias lt="exa --icons --group-directories-first -T"
  alias l="exa --icons --group-directories-first -l"
fi
if command -v batcat &> /dev/null; then
  alias cat="batcat --style=plain"
elif command -v bat &> /dev/null; then
  alias cat="bat --style=plain"
fi
if command -v fd &> /dev/null; then
  alias find="fd"
elif command -v fdfind &> /dev/null; then
  alias find="fdfind"
fi
if command -v rg &> /dev/null; then
  alias grep="rg"
fi
EOT

  print_message "$GREEN" "✅ Aliases do Ubuntu configurados com sucesso."
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
  else
    # Instalar Node.js diretamente via apt
    if confirm "Deseja instalar Node.js LTS diretamente via apt?"; then
      print_message "$YELLOW" "Instalando Node.js LTS via apt..."
      curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
      sudo apt-get install -y nodejs

      # Verificar instalação
      if command_exists node; then
        print_message "$GREEN" "✅ Node.js instalado com sucesso: $(node --version)"

        # Instalar PNPM
        if confirm "Deseja instalar PNPM?"; then
          npm install -g pnpm
        fi

        # Instalar Angular CLI
        if confirm "Deseja instalar Angular CLI?"; then
          npm install -g @angular/cli
        fi
      else
        print_message "$RED" "❌ Falha ao instalar Node.js."
      fi
    fi
  fi

  # Ferramentas para Git
  if confirm "Deseja instalar ferramentas avançadas para Git?"; then
    # Instalar lazygit
    if ! command_exists lazygit; then
      print_message "$YELLOW" "Instalando lazygit..."
      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      tar xf lazygit.tar.gz lazygit
      sudo install lazygit /usr/local/bin
      rm lazygit lazygit.tar.gz
    fi

    # Instalar gh cli
    if ! command_exists gh; then
      print_message "$YELLOW" "Instalando GitHub CLI (gh)..."
      type -p curl >/dev/null || sudo apt install curl -y
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
      sudo apt update
      sudo apt install gh -y
    fi

    # Instalar git-delta
    if ! command_exists delta; then
      print_message "$YELLOW" "Instalando git-delta..."
      wget -qO- "https://github.com/dandavison/delta/releases/download/0.16.5/delta-0.16.5-x86_64-unknown-linux-gnu.tar.gz" >/tmp/delta.tar.gz
      tar xzf /tmp/delta.tar.gz -C /tmp
      sudo mv /tmp/delta-*/delta /usr/local/bin/
      rm -rf /tmp/delta-* /tmp/delta.tar.gz
    fi
  fi

  # Verificar se Rust está instalado
  if ! command_exists cargo && confirm "Deseja instalar Rust?"; then
    print_message "$YELLOW" "Instalando Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"

    if command_exists rustc; then
      print_message "$GREEN" "✅ Rust instalado com sucesso: $(rustc --version)"
    else
      print_message "$RED" "❌ Falha ao instalar Rust."
    fi
  fi
}

# Instalar Starship prompt
install_starship() {
  print_message "$YELLOW" "Instalando Starship prompt..."

  if command_exists starship; then
    print_message "$GREEN" "✅ Starship já está instalado."
    return 0
  fi

  # Instalar via curl (método oficial)
  curl -sS https://starship.rs/install.sh | sh -s -- -y

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
export -f install_neovim_ubuntu
export -f check_and_add_neovim_ppa
export -f install_ubuntu_dependencies
export -f configure_ubuntu_aliases
export -f configure_python_for_neovim
export -f install_dev_tools
export -f install_starship
