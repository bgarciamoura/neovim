#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────
# Neovim Config — Dependency Installer
# Supports: macOS, Linux (apt/dnf/pacman), Windows (winget)
# ──────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()   { echo -e "${RED}[ERROR]${NC} $1"; }
step()  { echo -e "\n${BLUE}━━━ $1 ━━━${NC}"; }

# ── OS Detection ──────────────────────────────────────────

detect_os() {
  case "$(uname -s)" in
    Darwin)  OS="macos" ;;
    Linux)   OS="linux" ;;
    MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
    *)       err "OS not supported: $(uname -s)"; exit 1 ;;
  esac

  if [[ "$OS" == "linux" ]]; then
    if command -v apt-get &>/dev/null; then
      PKG_MANAGER="apt"
    elif command -v dnf &>/dev/null; then
      PKG_MANAGER="dnf"
    elif command -v pacman &>/dev/null; then
      PKG_MANAGER="pacman"
    else
      err "No supported package manager found (apt, dnf, pacman)"
      exit 1
    fi
  fi

  info "Detected: $OS${PKG_MANAGER:+ ($PKG_MANAGER)}"
}

# ── Helpers ───────────────────────────────────────────────

has() { command -v "$1" &>/dev/null; }

ensure_cmd() {
  local cmd="$1" name="${2:-$1}"
  if has "$cmd"; then
    ok "$name already installed"
    return 1
  fi
  return 0
}

install_pkg() {
  local name="$1"
  shift
  # Remaining args: macos_pkg linux_apt linux_dnf linux_pacman windows_pkg
  local macos_pkg="${1:-}" apt_pkg="${2:-}" dnf_pkg="${3:-}" pacman_pkg="${4:-}" win_pkg="${5:-}"

  case "$OS" in
    macos)   [[ -n "$macos_pkg" ]]  && brew install $macos_pkg ;;
    linux)
      case "$PKG_MANAGER" in
        apt)    [[ -n "$apt_pkg" ]]    && sudo apt-get install -y $apt_pkg ;;
        dnf)    [[ -n "$dnf_pkg" ]]    && sudo dnf install -y $dnf_pkg ;;
        pacman) [[ -n "$pacman_pkg" ]] && sudo pacman -S --noconfirm $pacman_pkg ;;
      esac ;;
    windows) [[ -n "$win_pkg" ]]   && winget install --accept-package-agreements --accept-source-agreements -e $win_pkg ;;
  esac
}

# ── Core System Dependencies ─────────────────────────────

install_git() {
  ensure_cmd git Git || return 0
  info "Installing Git..."
  install_pkg "git" "git" "git" "git" "git" "--id Git.Git"
}

install_node() {
  ensure_cmd node "Node.js" || return 0
  info "Installing Node.js..."
  install_pkg "node" "node" "nodejs npm" "nodejs npm" "nodejs npm" "--id OpenJS.NodeJS.LTS"
}

install_python() {
  # Check for python3 or python
  if has python3 || has python; then
    local pyver
    pyver="$(python3 --version 2>/dev/null || python --version 2>/dev/null)"
    ok "Python already installed ($pyver)"
    return 0
  fi
  info "Installing Python..."
  install_pkg "python" "python3" "python3 python3-pip python3-venv" "python3 python3-pip" "python python-pip" "--id Python.Python.3.12"
}

install_ripgrep() {
  ensure_cmd rg "ripgrep" || return 0
  info "Installing ripgrep..."
  install_pkg "ripgrep" "ripgrep" "ripgrep" "ripgrep" "ripgrep" "--id BurntSushi.ripgrep.MSVC"
}

install_unzip() {
  ensure_cmd unzip "unzip" || return 0
  if [[ "$OS" != "windows" ]]; then
    info "Installing unzip..."
    install_pkg "unzip" "unzip" "unzip" "unzip" "unzip" ""
  fi
}

install_curl() {
  ensure_cmd curl "curl" || return 0
  info "Installing curl..."
  install_pkg "curl" "curl" "curl" "curl" "curl" ""
}

install_imagemagick() {
  if has magick || has convert; then
    ok "ImageMagick already installed"
    return 0
  fi
  info "Installing ImageMagick..."
  install_pkg "imagemagick" "imagemagick" "imagemagick" "ImageMagick" "imagemagick" "--id ImageMagick.ImageMagick"
}

# ── macOS: Homebrew ───────────────────────────────────────

ensure_brew() {
  if has brew; then
    ok "Homebrew already installed"
    return 0
  fi
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# ── Windows: winget check ────────────────────────────────

ensure_winget() {
  if has winget; then
    ok "winget available"
    return 0
  fi
  err "winget not found. It comes pre-installed on Windows 11."
  err "If missing, install 'App Installer' from the Microsoft Store."
  exit 1
}

# ── Python Packages ──────────────────────────────────────

PIP_CMD=""

detect_pip() {
  if has pip3; then
    PIP_CMD="pip3"
  elif has pip; then
    PIP_CMD="pip"
  elif has python3; then
    PIP_CMD="python3 -m pip"
  elif has python; then
    PIP_CMD="python -m pip"
  else
    err "pip not found"
    exit 1
  fi
}

install_python_packages() {
  detect_pip

  local packages=(
    pynvim            # Neovim Python integration
    jupyter_client    # Molten: kernel communication
    nbformat          # Molten: notebook import/export
    cairosvg          # Molten: SVG rendering
    pillow            # Molten: image popup display
    pyperclip         # Molten: clipboard support
  )

  info "Installing Python packages: ${packages[*]}"
  $PIP_CMD install --user --upgrade "${packages[@]}"
  ok "Python packages installed"
}

# ── Flutter/Dart Check ───────────────────────────────────

check_flutter() {
  if has dart; then
    local dartver
    dartver="$(dart --version 2>&1 | head -1)"
    ok "Dart found ($dartver)"
  else
    warn "Dart/Flutter not found in PATH"
    warn "Install Flutter SDK: https://docs.flutter.dev/get-started/install"
    warn "dartls (Dart LSP) requires the Flutter SDK"
  fi
}

# ── image.nvim compatibility ─────────────────────────────

check_image_support() {
  if [[ "$OS" == "windows" ]]; then
    warn "image.nvim has limited support on Windows"
    warn "For image output in molten.nvim, consider using WezTerm terminal"
    warn "Or use text-only output (works without image.nvim)"
    return 0
  fi

  # Check for supported terminal
  local term_ok=false
  if [[ -n "${KITTY_PID:-}" ]]; then
    ok "Kitty terminal detected — image.nvim fully supported"
    term_ok=true
  elif [[ "${TERM_PROGRAM:-}" == "WezTerm" ]]; then
    ok "WezTerm detected — image.nvim supported via sixel"
    term_ok=true
  fi

  if [[ "$term_ok" == false ]]; then
    warn "No supported image terminal detected (Kitty/WezTerm)"
    warn "image.nvim requires Kitty >= 28.0, WezTerm, or a Sixel-capable terminal"
    warn "Molten will still work but without inline image rendering"
  fi
}

# ── Summary ──────────────────────────────────────────────

print_summary() {
  step "Installation Summary"

  local checks=(
    "git:git"
    "node:node"
    "python3:python3 python"
    "pip:pip3 pip"
    "rg:rg"
    "curl:curl"
    "dart:dart"
    "magick:magick convert"
    "nvim:nvim"
  )

  for entry in "${checks[@]}"; do
    local label="${entry%%:*}"
    local cmds="${entry#*:}"
    local found=false
    for cmd in $cmds; do
      if has "$cmd"; then
        found=true
        break
      fi
    done
    if $found; then
      echo -e "  ${GREEN}✓${NC} $label"
    else
      echo -e "  ${RED}✗${NC} $label"
    fi
  done

  echo ""
  info "Next steps:"
  info "  1. Open Neovim — vim.pack will install plugins on first launch"
  info "  2. Run :Mason to verify LSP servers are installed"
  info "  3. Run :checkhealth to verify everything is working"
}

# ── Main ─────────────────────────────────────────────────

main() {
  echo -e "${BLUE}"
  echo "  ╔═══════════════════════════════════════╗"
  echo "  ║  Neovim Config — Dependency Installer  ║"
  echo "  ╚═══════════════════════════════════════╝"
  echo -e "${NC}"

  detect_os

  # Package manager setup
  step "Package Manager"
  case "$OS" in
    macos)   ensure_brew ;;
    linux)   ok "Using $PKG_MANAGER" ;;
    windows) ensure_winget ;;
  esac

  # Core tools
  step "Core System Dependencies"
  install_git
  install_node
  install_python
  install_ripgrep
  install_curl
  install_unzip

  # Image support
  step "Image Support (for molten.nvim)"
  install_imagemagick
  check_image_support

  # Python packages
  step "Python Packages"
  install_python_packages

  # Flutter/Dart
  step "Flutter/Dart"
  check_flutter

  # Summary
  print_summary
}

main "$@"
