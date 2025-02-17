#!/bin/bash

echo "🚀 Setting up Neovim dependencies..."

# Atualizar pacotes do sistema
echo "🔄 Updating package list..."
sudo apt update && sudo apt upgrade -y # Para Debian/Ubuntu
# sudo pacman -Syu # Para Arch Linux
# sudo dnf update -y # Para Fedora

# Instalar dependências principais
echo "📦 Installing required packages..."
sudo apt install -y \
  neovim \
  curl \
  wget \
  git \
  unzip \
  tar \
  make \
  gcc \
  ripgrep \
  fd-find \
  python3-pip \
  nodejs \
  npm \
  luarocks \
  lazygit \
  bat

# Verificar se Neovim foi instalado corretamente
if command -v nvim &> /dev/null; then
  echo "✅ Neovim installed successfully!"
else
  echo "❌ Neovim installation failed!"
  exit 1
fi

# Instalar o gerenciador de plugins Lazy.nvim
echo "📦 Installing Lazy.nvim..."
git clone --depth 1 https://github.com/folke/lazy.nvim ~/.config/nvim/lazy

# Instalar Treesitter CLI para melhor syntax highlighting
echo "🌲 Installing Treesitter CLI..."
npm install -g tree-sitter-cli

# Instalar Markdownlint para validação de Markdown
echo "📄 Installing Markdownlint..."
npm install -g markdownlint-cli

# Instalar Prettier para formatação de código
echo "🎨 Installing Prettier..."
npm install -g prettier

# Instalar Neovim Python support
echo "🐍 Installing Neovim Python support..."
pip3 install --user pynvim

# Instalar LSPs necessários para TypeScript e outros
echo "🛠 Installing Language Servers..."
npm install -g typescript typescript-language-server
npm install -g vscode-langservers-extracted
npm install -g @tailwindcss/language-server
npm install -g eslint_d
npm install -g prettier

# Criar symlink para fd-find (caso esteja usando Debian/Ubuntu)
if ! command -v fd &> /dev/null; then
  echo "🔗 Creating symlink for fd..."
  ln -s $(which fdfind) ~/.local/bin/fd
fi

echo "🎉 All dependencies installed successfully! Open Neovim and enjoy 🚀"
