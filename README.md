# 🚀 Ultimate Neovim Development Environment

A powerful, feature-rich Neovim configuration designed for professional developers. This setup transforms Neovim into a full-featured IDE with intelligent code completion, Git integration, advanced navigation, performance diagnostics, and AI-powered assistance.

![Neovim Development Environment](https://raw.githubusercontent.com/yourusername/neovim-config/main/screenshots/dashboard.png)

## ✨ Features

- **🧠 AI-Powered Development** - GitHub Copilot integration with enhanced configuration and keyboard shortcuts
- **🔍 Smart Code Navigation** - Jump to definitions, references, and symbols with enhanced LSP capabilities
- **🔧 Comprehensive Language Support** - Full LSP integration for TypeScript, JavaScript, React, Angular, and more
- **🌲 Deep Code Analysis** - Treesitter for precise syntax highlighting and code understanding
- **🔄 Git Integration** - Seamless version control with GitSigns and LazyGit
- **🔍 Performance Analytics** - Built-in diagnostic tools to measure startup time and plugin performance
- **📊 Testing & Debugging** - Full DAP support for Node.js, TypeScript, Python, and more
- **🎨 Modern UI** - Beautiful themes, customizable dashboard, and intelligent status line
- **⚡ Lightning-Fast Performance** - Optimized lazy loading and performance monitoring

## 🖥️ Screenshots

![Code Editing](https://raw.githubusercontent.com/yourusername/neovim-config/main/screenshots/code-editing.png)
![Git Integration](https://raw.githubusercontent.com/yourusername/neovim-config/main/screenshots/git-integration.png)
![Performance Analytics](https://raw.githubusercontent.com/yourusername/neovim-config/main/screenshots/performance.png)

## 🔧 Installation

### Prerequisites

- Git
- A Nerd Font installed and configured in your terminal
- Internet connection for downloading packages

### Automatic Installation

We provide two installation scripts that handle everything automatically:

1. **`install-neovim.sh`**: Installs Neovim and core tools (Node.js, MISE, PNPM, Angular CLI)
2. **`install-neovim-deps.sh`**: Installs language servers, linters, formatters, and other tools

```bash
# Download the installation scripts
curl -LO https://raw.githubusercontent.com/bgarciamoura/neovim/main/install-neovim.sh
curl -LO https://raw.githubusercontent.com/bgarciamoura/neovim/main/install-neovim-deps.sh

# Make them executable
chmod +x install-neovim.sh install-neovim-deps.sh

# Run the main installation script
bash ./install-neovim.sh
```

The scripts will:
- Detect your operating system (macOS, Ubuntu/Debian, or Windows with WSL2)
- Install Neovim with the appropriate method for your system
- Set up MISE (modern version manager) for Node.js
- Install development tools like PNPM and Angular CLI (optional)
- Clone this Neovim configuration
- Install language servers, linters, and formatters
- Configure everything automatically

### Cross-Platform Support

#### macOS
- Automatically installs Homebrew if needed
- Installs Neovim nightly build for latest features
- Sets up environment for Apple Silicon or Intel processors

#### Ubuntu/Debian Linux
- Adds Neovim PPA for latest stable version
- Installs necessary dependencies from apt
- Sets up environment and tools appropriately

#### Windows
- Guides through WSL2 installation if needed
- Sets up Ubuntu on WSL2
- Installs all necessary components in the Linux environment

### Manual Installation

If you prefer to install manually:

```bash
# 1. Install Neovim (version 0.9.0 or later)
# macOS: brew install --HEAD neovim
# Ubuntu: add-apt-repository ppa:neovim-ppa/stable && apt-get update && apt-get install neovim

# 2. Clone the repository
git clone https://github.com/bgarciamoura/neovim ~/.config/nvim

# 3. Install dependencies manually
# - Node.js (LTS version recommended)
# - Python with pynvim package
# - Various LSP servers (typescript-language-server, lua-language-server, etc.)
# - Linters and formatters (eslint, prettier, stylua, etc.)

# 4. Start Neovim (plugins will install automatically)
nvim
```

## ⌨️ Key Features vs. VS Code

| Feature | This Neovim Config | VS Code |
|---------|--------|---------|
| **Startup Time** | Lightning fast (<100ms with diagnostics) | Several seconds |
| **Memory Usage** | Minimal (~100MB) | Heavy (500MB+) |
| **AI Integration** | Enhanced Copilot with better suggestions | Standard GitHub Copilot |
| **Performance Analytics** | Built-in diagnostics for plugins & startup | Limited extension profiling |
| **Customization** | Complete control with modular configuration | Limited to settings and extensions |
| **Keyboard-Driven** | Comprehensive Which-Key integration | Primarily mouse-driven |
| **Git Workflow** | Deeply integrated with specialized tools | Basic Git features |
| **Session Management** | Advanced persistence with context retention | Basic workspace saving |
| **Terminal Integration** | Seamless, highly configurable | Adequate but less integrated |
| **Framework Support** | Specialized tooling for Next.js, Angular, NestJS | Generic support via extensions |

## 🧩 Core Plugins

### Intelligent Coding
- **Copilot** - Enhanced AI suggestions with custom mappings and integration
- **nvim-cmp** - Advanced completion with LSP integration
- **Avante** - AI assistant integration
- **LuaSnip** - Powerful snippet engine with custom snippets for frameworks

### Navigation & Structure
- **Telescope** - Fuzzy finder with optimized configuration
- **Neo-tree** - File explorer with Git integration
- **Which-key** - Comprehensive keyboard shortcuts with documentation
- **Treesitter** - Advanced syntax highlighting and code navigation

### Developer Experience
- **Spectre** - Project-wide search and replace
- **Persistence** - Session management with intelligent saving
- **Diagnostic** - Performance measurement and optimization
- **Multicursor** - Multiple cursor support similar to VS Code

### Git Integration
- **GitSigns** - Shows Git diff markers in the gutter
- **LazyGit** - Full Git interface inside Neovim

### Backend Development
- **Typescript-tools** - Enhanced TypeScript/JavaScript support
- **Backend-frameworks** - Specialized support for NestJS, FastAPI, Django
- **DAP** - Debug Adapter Protocol with configurations for Node.js, Python

### DevOps & Containers
- **DevContainers** - Development in isolated containers
- **Docker** - Docker file editing and container management

### Styling & UI
- **Alpha** - Beautiful dashboard with performance metrics
- **Lualine** - Status line with Git and LSP integration
- **Cyberpunk/Morta** - Custom theme with Neovim optimizations
- **Noice** - Enhanced UI for notifications and command line

## 💡 Why This Configuration Stands Out

1. **Performance Obsessed** - Built-in diagnostics track startup time and plugin performance
2. **Framework Specialized** - Custom snippets and tooling for Next.js, Angular, NestJS, and more
3. **Enhanced AI Integration** - Optimized Copilot configuration for better suggestions
4. **Modular Design** - Easily add, remove, or modify components without breaking everything
5. **Full TypeScript Ecosystem** - Deep integration with TypeScript tools and frameworks
6. **Visual Feedback** - Beautiful UI that provides helpful information without being intrusive
7. **Container Ready** - Seamless development in Docker containers
8. **Testing First** - Integrated test runners for Jest and other frameworks

## 🤔 Making the Switch from VS Code

If you're coming from VS Code, here are some tips to ease the transition:

1. Press `Space` to access Which-Key and discover available commands
2. Use Alpha dashboard (startup screen) to access common actions
3. Learn basic Vim motions (`h`,`j`,`k`,`l`, `w`, `b`, etc.) to move efficiently
4. Use Telescope with `<Space>ff` for the familiar Quick Open experience
5. Try `<Space>a` commands to access AI features like Copilot

## 📚 Documentation

For more detailed documentation on all features and keyboard shortcuts, check the comments within each configuration file or use Which-Key in Neovim by pressing the space bar.

## 🔑 Key Bindings Cheat Sheet

Press `Space` to see a comprehensive menu of commands organized by category:

- **f** - Files and search
- **g** - Git operations
- **l** - LSP and code navigation
- **c** - Code and clipboard operations
- **d** - Debugging
- **t** - Terminal
- **a** - AI assistance (Copilot, Avante)
- **j** - Testing (Jest, etc.)
- **w** - Window management
- **b** - Buffer operations
- **x** - Exit and session operations

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This Neovim configuration is released under the MIT License.
