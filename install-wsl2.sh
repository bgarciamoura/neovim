# Verificar versões atuais e disponíveis
    check_neovim_versions
    
    # Verificar se Neovim já está instalado
    if command_exists nvim; then
        local nvim_version=$(nvim --version | head -n 1)
        print_message "$GREEN" "Neovim já está instalado: $nvim_version"
        if confirm "Deseja reinstalar/atualizar o Neovim para a versão de desenvolvimento mais recente?"; then
            print_message "$YELLOW" "Prosseguindo com a reinstalação/atualização..."
        else
            print_message "$YELLOW" "Mantendo a instalação atual do Neovim."
            return 0
        fi
    fi#!/bin/bash
# install-wsl2.sh - Módulo para configuração do Windows com WSL2
# Este arquivo é chamado pelo script principal install-neovim.sh

# Importar utilitários comuns se não estiverem definidos
if [[ -z "$UTILS_IMPORTED" ]]; then
    source "./install-utils.sh"
fi

# Função para configurar WSL2 e Ubuntu no Windows
setup_wsl2_windows() {
    print_message "$BLUE" "==== Configurando WSL2 e Ubuntu no Windows ===="
    
    # Verificar se estamos no Windows
    if [ -z "$WINDIR" ] && [ -z "$windir" ]; then
        print_message "$RED" "Esta função deve ser executada no Windows CMD ou PowerShell."
        return 1
    fi
    
    # Criar um script PowerShell temporário para instalar WSL2 e Ubuntu
    TEMP_PS_SCRIPT=$(mktemp -u).ps1
    cat > "$TEMP_PS_SCRIPT" << 'EOL'
# Verificar se WSL já está habilitado
$wslStatus = wsl --status 2>&1
if ($wslStatus -match "WSL não está instalado") {
    Write-Host "Habilitando recursos necessários do Windows..."
    # Habilitar recursos do Windows necessários
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    
    Write-Host "É necessário reiniciar o computador para prosseguir."
    $restart = Read-Host "Deseja reiniciar agora? (S/N)"
    if ($restart -eq "S" -or $restart -eq "s") {
        Write-Host "Reiniciando o computador em 10 segundos..."
        Start-Sleep -Seconds 10
        Restart-Computer -Force
        exit
    } else {
        Write-Host "Por favor, reinicie o computador manualmente e execute este script novamente."
        exit
    }
}

# Verificar se WSL2 está configurado
$wslVersion = wsl --list --verbose 2>&1
if (-not ($wslVersion -match "2")) {
    Write-Host "Baixando e instalando o pacote de atualização do kernel do Linux..."
    $kernelUpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
    $kernelUpdateFile = "$env:TEMP\wsl_update_x64.msi"
    Invoke-WebRequest -Uri $kernelUpdateUrl -OutFile $kernelUpdateFile
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", $kernelUpdateFile, "/quiet", "/norestart" -Wait
    
    Write-Host "Definindo WSL2 como versão padrão..."
    wsl --set-default-version 2
}

# Verificar se Ubuntu está instalado
$ubuntuInstalled = wsl --list | Select-String "Ubuntu"
if (-not $ubuntuInstalled) {
    Write-Host "Instalando Ubuntu..."
    # Método 1: Usando winget (disponível no Windows 10 mais recente)
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install Canonical.Ubuntu
    } else {
        # Método 2: Usando Microsoft Store
        Write-Host "Abrindo Microsoft Store para instalação do Ubuntu..."
        Start-Process "ms-windows-store://pdp/?productid=9PDXGNCFSCZV"
        Write-Host "Por favor, instale o Ubuntu a partir da Microsoft Store e execute este script novamente."
        exit
    }
}

# Inicializar Ubuntu pela primeira vez e configurar ZSH
Write-Host "Inicializando Ubuntu... Você precisará definir um nome de usuário e senha."
wsl -d Ubuntu

# Configurar ZSH no Ubuntu
Write-Host "Configurando ZSH no Ubuntu..."
wsl -d Ubuntu -e bash -c "if ! command -v zsh > /dev/null; then sudo apt update && sudo apt install -y zsh; fi"
wsl -d Ubuntu -e bash -c "sudo chsh -s $(which zsh) $(whoami)"
wsl -d Ubuntu -e bash -c "mkdir -p ~/.config/zsh"
wsl -d Ubuntu -e bash -c "echo 'export ZDOTDIR=\"\$HOME/.config/zsh\"' > ~/.zshenv"

# Configurar o ambiente ZSH com arquivos básicos
wsl -d Ubuntu -e bash -c "mkdir -p ~/.config/zsh"
wsl -d Ubuntu -e bash -c "cat > ~/.config/zsh/.zshrc << 'EOZSHRC'
# Configuração básica do ZSH
export HISTFILE=\"\$HOME/.config/zsh/.zsh_history\"
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
export PATH=\"\$HOME/.local/bin:\$PATH\"

# Suporte a Starship se instalado
if command -v starship &> /dev/null; then
    eval \"\$(starship init zsh)\"
fi

# Suporte a MISE se instalado
if command -v mise &> /dev/null; then
    eval \"\$(mise activate zsh)\"
fi
EOZSHRC"

Write-Host "Configuração completa! Ubuntu no WSL2 está instalado e pronto para uso com ZSH como shell padrão."
Write-Host "Para acessá-lo, abra o Prompt de Comando ou PowerShell e digite 'wsl' ou 'ubuntu'."
EOL
    
    print_message "$YELLOW" "Um script PowerShell foi criado para instalar o WSL2 e Ubuntu com ZSH."
    print_message "$YELLOW" "Execute o seguinte comando no PowerShell com privilégios de administrador:"
    print_message "$CYAN" "powershell.exe -ExecutionPolicy Bypass -File \"$TEMP_PS_SCRIPT\""
    
    # Fornecer instruções para iniciar o script PowerShell
    print_message "$YELLOW" "Após a instalação do WSL2 e Ubuntu, execute este script novamente dentro do Ubuntu para instalar o Neovim."
    
    # Salvar o caminho do script para referência futura
    mkdir -p ~/.config/neovim-install
    echo "$TEMP_PS_SCRIPT" > ~/.config/neovim-install/last_wsl_script.txt
    
    return 0
}

# Função para instalar Neovim no WSL já configurado
install_neovim_wsl() {
  print_message "$BLUE" "==== Instalando Neovim (nightly) diretamente do GitHub ===="

  # Verifica se o jq está instalado (necessário para processar JSON)
  if ! command_exists jq; then
    print_message "$RED" "❌ jq não está instalado. Por favor, instale-o para prosseguir."
    return 1
  fi

 # Obter a arquitetura do kernel
  arch=$(uname -m)

  # Obter JSON dos releases e remover caracteres de controle com iconv
  releases_json=$(curl -s https://api.github.com/repos/neovim/neovim/releases | iconv -c)

  # Extrair a URL do asset para Linux (nvim-linux64.tar.gz)
  asset_url=$(echo "$releases_json" | jq -r --arg arch "$arch" '.[] 
  | select(.tag_name=="nightly") 
  | .assets 
  | .[] 
  | select(.name | contains(".tar.gz") and contains("linux") and contains($arch)) 
  | .browser_download_url')
 
  if [ -z "$asset_url" ]; then
    print_message "$RED" "❌ Não foi possível encontrar o asset do Neovim para Linux."
    return 1
  fi

  print_message "$YELLOW" "Baixando Neovim da URL: $asset_url"
  tmp_dir=$(mktemp -d)
  curl -L -o "$tmp_dir/nvim-linux64.tar.gz" "$asset_url"

  print_message "$YELLOW" "Extraindo o pacote..."
  tar -xzf "$tmp_dir/nvim-linux64.tar.gz" -C "$tmp_dir"

  # Supondo que a extração crie o diretório 'nvim-linux64'
  sudo cp "$tmp_dir/nvim-linux64/bin/nvim" /usr/local/bin/
  sudo cp -r "$tmp_dir/nvim-linux64/share" /usr/local/

  rm -rf "$tmp_dir"

  if command_exists nvim; then
    print_message "$GREEN" "✅ Neovim instalado com sucesso: $(nvim --version | head -n 1)"
    return 0
  else
    print_message "$RED" "❌ Falha ao instalar Neovim via GitHub."
    return 1
  fi


# Função interna para configurar o ZSH no WSL
configure_zsh_for_wsl() {
    print_message "$YELLOW" "Configurando ZSH no WSL..."
    
    # Verificar se ZSH está instalado
    if ! command_exists zsh; then
        print_message "$YELLOW" "Instalando ZSH..."
        sudo apt-get update
        sudo apt-get install -y zsh
    fi
    
    # Configurar ZSH como shell padrão se ainda não estiver
    if [[ "$SHELL" != *"zsh"* ]]; then
        print_message "$YELLOW" "Configurando ZSH como shell padrão..."
        chsh -s $(which zsh)
    fi
    
    # Configurar diretório .config/zsh
    mkdir -p ~/.config/zsh
    
    # Verificar se .zshenv existe
    if [ ! -f ~/.zshenv ]; then
        print_message "$YELLOW" "Criando .zshenv para apontar para ~/.config/zsh..."
        echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv
    fi
    
    # Criar um .zshrc básico se não existir
    if [ ! -f ~/.config/zsh/.zshrc ]; then
        print_message "$YELLOW" "Criando .zshrc básico..."
        cat > ~/.config/zsh/.zshrc << 'EOZSHRC'
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

# Configuração para WSL
# Melhoria para interoperabilidade com Windows
export BROWSER="wslview"

# Suporte a Starship se instalado
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Suporte a MISE se instalado
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi
EOZSHRC
    fi
    
    print_message "$GREEN" "✅ ZSH configurado com sucesso no WSL"
}

# Função interna para instalar Neovim no Ubuntu (compartilhada com o módulo Ubuntu)
install_neovim_ubuntu_internal() {
    # Verificar se o repositório unstable/nightly do Neovim já está adicionado
    if ! grep -q "^deb.*neovim-ppa/unstable" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        print_message "$YELLOW" "Adicionando repositório PPA do Neovim (versão unstable/nightly)..."
        sudo apt-get update
        sudo apt-get install -y software-properties-common
        
        # Remover repositório estável se existir
        if grep -q "^deb.*neovim-ppa/unstable" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
            print_message "$YELLOW" "Removendo repositório estável do Neovim..."
            sudo add-apt-repository --remove -y ppa:neovim-ppa/unstable
        fi
        
        # Adicionar repositório unstable
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
    fi
    
    # Atualizar e instalar Neovim (versão nightly)
    print_message "$YELLOW" "Atualizando repositórios e instalando a versão nightly do Neovim..."
    sudo apt-get update
    sudo apt-get install -y neovim
    
    # Verificar se é realmente a versão nightly
    if nvim --version | grep -q "NVIM v0.9" || ! nvim --version | grep -q "NVIM"; then
        print_message "$YELLOW" "A versão instalada parece não ser a nightly. Tentando reinstalar forçando a versão mais recente..."
        sudo apt-get install -y --reinstall neovim
    fi
    
    # Configurar alias para fd (caso esteja usando fd-find)
    if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        print_message "$YELLOW" "Configurando alias para fd-find..."
        mkdir -p ~/.local/bin
        ln -sf $(which fdfind) ~/.local/bin/fd
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.config/zsh/.zshrc
    fi
    
    # Instalar dependências do Python para Neovim
    print_message "$YELLOW" "Instalando suporte do Python para Neovim..."
    pip3 install --user --upgrade pip
    pip3 install --user pynvim
    
    # Perguntar se deve instalar Node.js via MISE
    if confirm "Deseja instalar Node.js via MISE (recomendado)?"; then
        if ! command_exists mise; then
            # Instalar MISE
            print_message "$YELLOW" "Instalando MISE..."
            curl https://mise.jdx.dev/install.sh | sh
            
            # Adicionar MISE à configuração do ZSH
            echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.config/zsh/.zshrc
            
            # Carregar MISE para uso imediato
            export PATH="$HOME/.local/bin:$PATH"
            eval "$(~/.local/bin/mise activate bash)"
        fi
        
        # Instalar Node.js via MISE
        print_message "$YELLOW" "Instalando Node.js LTS via MISE..."
        mise install nodejs@lts
        mise use nodejs@lts
        
        # Instalar pacotes Node.js globais
        print_message "$YELLOW" "Instalando pacotes Node.js globais via MISE..."
        mise x nodejs -- npm install -g neovim
        
        # Instalar tree-sitter apenas se não existir
        if ! command_exists tree-sitter; then
            mise x nodejs -- npm install -g tree-sitter-cli
        fi
    else
        # Instalar Node.js diretamente
        print_message "$YELLOW" "Instalando Node.js diretamente via apt..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
        
        # Instalar pacotes Node.js globais
        print_message "$YELLOW" "Instalando pacotes Node.js globais..."
        sudo npm install -g neovim
        
        # Instalar tree-sitter apenas se não existir
        if ! command_exists tree-sitter; then
            sudo npm install -g tree-sitter-cli
        fi
    fi
    
    print_message "$GREEN" "✅ Neovim instalado com sucesso no WSL Ubuntu!"
    print_message "$GREEN" "Para verificar a instalação, execute: nvim --version"
}

# Exportar as funções para uso no script principal
export -f setup_wsl2_windows
export -f install_neovim_wsl
export -f configure_zsh_for_wsl
export -f install_neovim_ubuntu_internal
