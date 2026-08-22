#!/usr/bin/env bash
# Download avante.nvim's prebuilt native libraries (tokenizers, templates,
# repo-map, html2md) for the checked-out release tag.
#
# Replaces the plugin's own build.sh, which still queries the old
# `yetone/avante.nvim` releases and `v*` tags; releases now live under
# `avante-corp/avante.nvim` with `release-v*` tags. No Rust toolchain needed.
#
# Run from the plugin directory (the PackChanged hook in
# lua/config/plugins.lua sets cwd to it).

set -euo pipefail

REPO="avante-corp/avante.nvim"
TARGET_DIR="lua"          # avante loads the .so files from lua/ via package.cpath
LUA_VERSION="${LUA_VERSION:-luajit}"

case "$(uname -s)" in
  Linux)  PLATFORM="linux" ;;
  Darwin) PLATFORM="darwin" ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

case "$(uname -m)" in
  x86_64|amd64)   ARCH="x86_64" ;;
  aarch64|arm64)  ARCH="aarch64" ;;
  *) echo "Unsupported arch: $(uname -m)" >&2; exit 1 ;;
esac

# Make sure release tags are present (vim.pack clones with --filter=blob:none)
git fetch --quiet --tags origin 2>/dev/null || true

tag="$(git describe --tags --abbrev=0 --match 'release-v*' 2>/dev/null || true)"
if [[ -z "$tag" ]]; then
  echo "No release-v* tag found; cannot pick a prebuilt artifact" >&2
  exit 1
fi

built_tag="$(cat "$TARGET_DIR/.tag" 2>/dev/null || true)"
if [[ "$built_tag" == "$tag" ]]; then
  echo "avante.nvim prebuilt libs already at $tag"
  exit 0
fi

artifact="avante_lib-${PLATFORM}-${ARCH}-${LUA_VERSION}.tar.gz"
url="https://github.com/${REPO}/releases/download/${tag}/${artifact}"

echo "Downloading $artifact for $tag…"
mkdir -p "$TARGET_DIR"
# The archive wraps the .so files in a results/ directory; flatten into lua/
curl -fsSL "$url" | tar -xz --strip-components=1 -C "$TARGET_DIR"
echo "$tag" > "$TARGET_DIR/.tag"
echo "Installed avante.nvim native libs ($tag) into $TARGET_DIR/"
