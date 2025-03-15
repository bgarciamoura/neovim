#!/bin/bash

# Cores para melhor legibilidade
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Versões
NODE_VERSION="lts"
PNPM_VERSION="latest"
ANGULAR_CLI_VERSION="latest"

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

# Função para instalar o MISE (gerenciador de versões)
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
        
        # Adicionar mise ao ambiente
        if [[ -f ~/.bashrc ]]; then
            echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
        fi
        if [[ -f ~/.zshrc ]]; then
            echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
        fi
        if [[ -f ~/.config/fish/config.fish ]]; then
            echo 'mise activate fish | source' >> ~/.config/fish/config.fish
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
            if (( major_version % 2 != 0 )); then
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
    if mise x nodejs -- node --version &> /dev/null; then
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
                echo -e "\n[tools]\nnodejs = \"lts\"" >> ~/.config/mise/config.toml
            fi
        else
            # Cria um novo arquivo config.toml
            echo -e "[tools]\nnodejs = \"lts\"" > ~/.config/mise/config.toml
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
        print_message "$GREEN" "✅ PNPM instalado com sucesso."
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

# Função para instalar Neovim em sistemas baseados em Ubuntu
install_neovim_ubuntu() {
    print_message "$BLUE" "==== Instalando Neovim na versão mais recente no Ubuntu ===="
    
    # Verificar se Neovim já está instalado
    if command_exists nvim; then
        local nvim_version=$(nvim --version | head -n 1)
        print_message "$GREEN" "Neovim já está instalado: $nvim_version"
        if confirm "Deseja reinstalar/atualizar o Neovim?"; then
            print_message "$YELLOW" "Prosseguindo com a reinstalação/atualização..."
        else
            print_message "$YELLOW" "Mantendo a instalação atual do Neovim."
            return 0
        fi
    fi
    
    # Verificar se o repositório estável do Neovim já está adicionado
    if ! grep -q "^deb.*neovim-ppa/stable" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        print_message "$YELLOW" "Adicionando repositório PPA do Neovim..."
        sudo apt-get update
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:neovim-ppa/stable
    fi
    
    # Atualizar e instalar Neovim
    print_message "$YELLOW" "Atualizando repositórios e instalando Neovim..."
    sudo apt-get update
    sudo apt-get install -y neovim
    
    # Instalar dependências comuns
    print_message "$YELLOW" "Instalando dependências comuns para desenvolvimento..."
    sudo apt-get install -y \
        git \
        curl \
        wget \
        unzip \
        ripgrep \
        fd-find \
        python3-pip
    
    # Configurar alias para fd (caso esteja usando fd-find)
    if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        print_message "$YELLOW" "Configurando alias para fd-find..."
        mkdir -p ~/.local/bin
        ln -sf $(which fdfind) ~/.local/bin/fd
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        
        # Adicionar também para fish shell se existir
        if [ -d ~/.config/fish ]; then
            mkdir -p ~/.config/fish
            echo 'fish_add_path ~/.local/bin' >> ~/.config/fish/config.fish
        fi
    fi
    
    # Instalar dependências do Python para Neovim
    print_message "$YELLOW" "Instalando suporte do Python para Neovim..."
    pip3 install --user --upgrade pip
    pip3 install --user pynvim
    
    # Perguntar se deve instalar através do MISE
    if confirm "Deseja instalar Node.js via MISE (recomendado)?"; then
        install_mise
        install_nodejs_mise
        
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
    
    print_message "$GREEN" "✅ Neovim foi instalado com sucesso no Ubuntu!"
    print_message "$GREEN" "Para verificar a instalação, execute: nvim --version"
    
    # Instalar ferramentas adicionais se desejado
    if confirm "Deseja instalar PNPM?"; then
        install_pnpm
    fi
    
    if confirm "Deseja instalar Angular CLI?"; then
        install_angular_cli
    fi
}

# Função para instalar Neovim no macOS
install_neovim_macos() {
    print_message "$BLUE" "==== Instalando Neovim no macOS ===="
    
    # Verificar se Neovim já está instalado
    if command_exists nvim; then
        local nvim_version=$(nvim --version | head -n 1)
        print_message "$GREEN" "Neovim já está instalado: $nvim_version"
        if confirm "Deseja reinstalar/atualizar o Neovim?"; then
            print_message "$YELLOW" "Prosseguindo com a reinstalação/atualização..."
        else
            print_message "$YELLOW" "Mantendo a instalação atual do Neovim."
            return 0
        fi
    fi
    
    # Verificar se o Homebrew está instalado
    if ! command_exists brew; then
        print_message "$YELLOW" "Homebrew não encontrado. Instalando Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Adicionar Homebrew ao PATH
        if [[ -f ~/.zshrc ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f ~/.bash_profile ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f ~/.config/fish/config.fish ]]; then
            echo 'eval (/opt/homebrew/bin/brew shellenv)' >> ~/.config/fish/config.fish
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        print_message "$GREEN" "✅ Homebrew instalado com sucesso!"
    else
        print_message "$GREEN" "✅ Homebrew já está instalado."
    fi
    
    # Instalar Neovim (versão nightly)
    print_message "$YELLOW" "Instalando Neovim (versão nightly)..."
    brew install --HEAD neovim
    
    # Instalar dependências comuns
    print_message "$YELLOW" "Instalando dependências comuns para desenvolvimento..."
    brew install \
        git \
        curl \
        wget \
        ripgrep \
        fd \
        python3
    
    # Atualizar pip primeiro
    print_message "$YELLOW" "Atualizando pip..."
    python3 -m pip install --upgrade pip
    
    # Instalar dependências do Python para Neovim
    print_message "$YELLOW" "Instalando suporte do Python para Neovim..."
    python3 -m pip install --user pynvim
    
    # Perguntar se deve instalar através do MISE
    if confirm "Deseja instalar Node.js via MISE (recomendado)?"; then
        install_mise
        install_nodejs_mise
        
        # Instalar pacotes Node.js globais
        print_message "$YELLOW" "Instalando pacotes Node.js globais via MISE..."
        mise x nodejs -- npm install -g neovim
        
        # Instalar tree-sitter apenas se não existir
        if ! command_exists tree-sitter; then
            mise x nodejs -- npm install -g tree-sitter-cli
        fi
    else
        # Instalar Node.js diretamente
        print_message "$YELLOW" "Instalando Node.js via Homebrew..."
        if ! brew list node &>/dev/null; then
            brew install node
        else
            print_message "$GREEN" "Node.js já está instalado via Homebrew."
        fi
        
        # Instalar pacotes Node.js globais
        print_message "$YELLOW" "Instalando pacotes Node.js globais..."
        npm install -g neovim
        
        # Instalar tree-sitter apenas se não existir
        if ! command_exists tree-sitter; then
            npm install -g tree-sitter-cli
        else
            print_message "$GREEN" "tree-sitter já está instalado."
        fi
    fi
    
    print_message "$GREEN" "✅ Neovim (nightly) foi instalado com sucesso no macOS!"
    print_message "$GREEN" "Para verificar a instalação, execute: nvim --version"
    
    # Instalar ferramentas adicionais se desejado
    if confirm "Deseja instalar PNPM?"; then
        install_pnpm
    fi
    
    if confirm "Deseja instalar Angular CLI?"; then
        install_angular_cli
    fi
}

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

# Inicializar Ubuntu pela primeira vez
Write-Host "Inicializando Ubuntu... Você precisará definir um nome de usuário e senha."
wsl -d Ubuntu

Write-Host "Configuração completa! Ubuntu no WSL2 está instalado e pronto para uso."
Write-Host "Para acessá-lo, abra o Prompt de Comando ou PowerShell e digite 'wsl' ou 'ubuntu'."
EOL
    
    print_message "$YELLOW" "Um script PowerShell foi criado para instalar o WSL2 e Ubuntu."
    print_message "$YELLOW" "Execute o seguinte comando no PowerShell com privilégios de administrador:"
    print_message "$CYAN" "powershell.exe -ExecutionPolicy Bypass -File \"$TEMP_PS_SCRIPT\""
    
    # Fornecer instruções para iniciar o script PowerShell
    print_message "$YELLOW" "Após a instalação do WSL2 e Ubuntu, execute este script novamente dentro do Ubuntu para instalar o Neovim."
}

# Função principal
main() {
    print_message "$MAGENTA" "===== Script de Instalação do Neovim ====="
    print_message "$CYAN" "Este script detectará seu sistema operacional e instalará o Neovim adequadamente."
    print_message "$CYAN" "Inclui também opções para instalar MISE, Node.js, PNPM e Angular CLI."
    
    # Detectar o sistema operacional
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        print_message "$GREEN" "Sistema detectado: macOS"
        if confirm "Deseja prosseguir com a instalação no macOS?"; then
            install_neovim_macos
            
            # Perguntar sobre instalações adicionais se não forem instaladas durante o processo do Neovim
            if command_exists mise || confirm "Deseja instalar MISE separadamente?"; then
                install_mise
            fi
            
            if command_exists mise && confirm "Deseja configurar ferramentas de desenvolvimento adicionais?"; then
                print_message "$YELLOW" "Configurando ferramentas adicionais..."
                
                if ! mise ls --installed | grep -q "nodejs"; then
                    install_nodejs_mise
                fi
                
                if ! command_exists pnpm && confirm "Instalar PNPM?"; then
                    install_pnpm
                fi
                
                if ! command_exists ng && confirm "Instalar Angular CLI?"; then
                    install_angular_cli
                fi
            fi
        else
            print_message "$YELLOW" "Instalação cancelada pelo usuário."
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if grep -qi "ubuntu" /etc/os-release 2>/dev/null || grep -qi "debian" /etc/os-release 2>/dev/null; then
            print_message "$GREEN" "Sistema detectado: Ubuntu/Debian"
            if confirm "Deseja prosseguir com a instalação no Ubuntu/Debian?"; then
                install_neovim_ubuntu
                
                # Perguntar sobre instalações adicionais se não forem instaladas durante o processo do Neovim
                if command_exists mise || confirm "Deseja instalar MISE separadamente?"; then
                    install_mise
                fi
                
                if command_exists mise && confirm "Deseja configurar ferramentas de desenvolvimento adicionais?"; then
                    print_message "$YELLOW" "Configurando ferramentas adicionais..."
                    
                    if ! mise ls --installed | grep -q "nodejs"; then
                        install_nodejs_mise
                    fi
                    
                    if ! command_exists pnpm && confirm "Instalar PNPM?"; then
                        install_pnpm
                    fi
                    
                    if ! command_exists ng && confirm "Instalar Angular CLI?"; then
                        install_angular_cli
                    fi
                fi
            else
                print_message "$YELLOW" "Instalação cancelada pelo usuário."
            fi
        else
            print_message "$RED" "Sistema Linux detectado, mas não é Ubuntu/Debian."
            print_message "$YELLOW" "Este script suporta atualmente apenas Ubuntu/Debian."
            exit 1
        fi
    elif [[ -n "$WINDIR" || -n "$windir" ]]; then
        # Windows (CMD/PowerShell)
        print_message "$GREEN" "Sistema detectado: Windows"
        if confirm "Deseja configurar WSL2 e Ubuntu para usar o Neovim?"; then
            setup_wsl2_windows
            print_message "$YELLOW" "Após configurar o WSL2 e Ubuntu, execute este script novamente dentro do Ubuntu."
        else
            print_message "$YELLOW" "Instalação cancelada pelo usuário."
        fi
    elif [[ $(uname -r) == *"WSL"* || $(uname -r) == *"microsoft"* ]]; then
        # WSL
        print_message "$GREEN" "Sistema detectado: WSL (Ubuntu)"
        if confirm "Deseja prosseguir com a instalação no WSL?"; then
            install_neovim_ubuntu
            
            # Perguntar sobre instalações adicionais se não forem instaladas durante o processo do Neovim
            if command_exists mise || confirm "Deseja instalar MISE separadamente?"; then
                install_mise
            fi
            
            if command_exists mise && confirm "Deseja configurar ferramentas de desenvolvimento adicionais?"; then
                print_message "$YELLOW" "Configurando ferramentas adicionais..."
                
                if ! mise ls --installed | grep -q "nodejs"; then
                    install_nodejs_mise
                fi
                
                if ! command_exists pnpm && confirm "Instalar PNPM?"; then
                    install_pnpm
                fi
                
                if ! command_exists ng && confirm "Instalar Angular CLI?"; then
                    install_angular_cli
                fi
            fi
        else
            print_message "$YELLOW" "Instalação cancelada pelo usuário."
        fi
    else
        print_message "$RED" "Sistema operacional não suportado."
        print_message "$YELLOW" "Este script suporta macOS, Ubuntu/Debian e Windows (para configurar WSL2)."
        exit 1
    fi
    
    print_message "$MAGENTA" "===== Processo de instalação concluído ====="
    
    # Mostrar resumo das ferramentas instaladas
    print_message "$BLUE" "===== Resumo das ferramentas instaladas ====="
    
    if command_exists nvim; then
        print_message "$GREEN" "✅ Neovim: $(nvim --version | head -n 1)"
    else
        print_message "$RED" "❌ Neovim não foi instalado"
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
    
    # Verificar se o script de dependências existe e perguntar se deve executá-lo
    DEPS_SCRIPT="./install-neovim-deps.sh"
    if [ -f "$DEPS_SCRIPT" ]; then
        if confirm "Deseja instalar as dependências específicas para sua configuração do Neovim?"; then
            print_message "$BLUE" "==== Executando script de dependências do Neovim ===="
            chmod +x "$DEPS_SCRIPT"
            bash "$DEPS_SCRIPT"
        else
            print_message "$YELLOW" "Instalação de dependências ignorada pelo usuário."
        fi
    else
        print_message "$YELLOW" "Script de dependências não encontrado ($DEPS_SCRIPT)."
        print_message "$YELLOW" "Se desejar instalar dependências específicas para o Neovim, crie ou baixe o script de dependências."
    fi
}

# Executar a função principal
main
