#!/bin/bash
# install-neovim.sh - Script principal modularizado para instalação do Neovim e ambiente de desenvolvimento

# Verificar se o script está sendo executado com permissões adequadas
if [ "$EUID" -eq 0 ]; then
  echo "Por favor, não execute este script como root/sudo diretamente."
  echo "O script solicitará sudo quando necessário."
  exit 1
fi

# Carregar o módulo de utilitários
source ./install-utils.sh

print_message "$MAGENTA" "===== Script de Instalação do Neovim ====="
print_message "$CYAN" "Este script detectará seu sistema operacional e instalará o Neovim adequadamente."
print_message "$CYAN" "Inclui também opções para instalar ZSH, MISE, Node.js, PNPM e Angular CLI."

# Detectar o sistema operacional
OS_TYPE=$(detect_os)
print_message "$BLUE" "Sistema operacional detectado: $OS_TYPE"

# Verificar dependências básicas
check_basic_dependencies

# Carregar o módulo específico para o sistema operacional e executar a instalação
case "$OS_TYPE" in
"macos")
  print_message "$GREEN" "Sistema detectado: macOS"
  if confirm "Deseja prosseguir com a instalação no macOS?"; then
    # Carregar módulo macOS
    source ./install-macos.sh

    # Instalar ZSH primeiro
    install_zsh

    # Instalar Neovim
    install_neovim_macos
  else
    print_message "$YELLOW" "Instalação cancelada pelo usuário."
    exit 0
  fi
  ;;
"ubuntu")
  print_message "$GREEN" "Sistema detectado: Ubuntu/Debian"
  if confirm "Deseja prosseguir com a instalação no Ubuntu/Debian?"; then
    # Carregar módulo Ubuntu
    source ./install-ubuntu.sh

    # Instalar ZSH primeiro
    install_zsh

    # Instalar Neovim
    install_neovim_ubuntu
  else
    print_message "$YELLOW" "Instalação cancelada pelo usuário."
    exit 0
  fi
  ;;
"windows")
  print_message "$GREEN" "Sistema detectado: Windows"
  if confirm "Deseja configurar WSL2 e Ubuntu para usar o Neovim?"; then
    # Carregar módulo WSL2
    source ./install-wsl2.sh

    # Configurar WSL2
    setup_wsl2_windows

    print_message "$YELLOW" "Após configurar o WSL2 e Ubuntu, execute este script novamente dentro do Ubuntu."
    exit 0
  else
    print_message "$YELLOW" "Instalação cancelada pelo usuário."
    exit 0
  fi
  ;;
"wsl")
  print_message "$GREEN" "Sistema detectado: WSL (Ubuntu)"
  if confirm "Deseja prosseguir com a instalação no WSL?"; then
    # Carregar módulo WSL2
    source ./install-wsl2.sh

    # Instalar ZSH primeiro
    install_zsh

    # Instalar Neovim no WSL
    install_neovim_wsl
  else
    print_message "$YELLOW" "Instalação cancelada pelo usuário."
    exit 0
  fi
  ;;
*)
  print_message "$RED" "Sistema operacional não suportado: $OS_TYPE"
  print_message "$YELLOW" "Este script suporta macOS, Ubuntu/Debian e Windows (para configurar WSL2)."
  exit 1
  ;;
esac

print_message "$MAGENTA" "===== Processo de instalação concluído ====="

# Gerar relatório de instalação
generate_installation_report

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

print_message "$GREEN" "Instalação completa! Você pode iniciar o Neovim executando: nvim"
print_message "$BLUE" "Versão do Neovim instalada: $(nvim --version | head -n 1)"
print_message "$YELLOW" "Lembre-se de abrir um novo terminal ou executar 'source ~/.zshenv' para aplicar as alterações."

print_message "$MAGENTA" "Importante: Foi instalada a versão de desenvolvimento (nightly) do Neovim,"
print_message "$MAGENTA" "que é recomendada para plugins que necessitam dos recursos mais recentes."
