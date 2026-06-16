#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_file() {
  local source_file="$1"
  local target_file="$2"

  mkdir -p "$(dirname "$target_file")"

  if [ -L "$target_file" ] || [ -f "$target_file" ]; then
    rm -f "$target_file"
  fi

  ln -s "$source_file" "$target_file"
  echo "Enlace creado: $target_file -> $source_file"
}

# ──────────────────────────────────────────────
# 1. JetBrainsMono Nerd Font
# ──────────────────────────────────────────────
echo ""
echo "==> Instalando JetBrainsMono Nerd Font..."

NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
FONT_DIR="$HOME/.local/share/fonts"
FONT_FILE="$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf"

mkdir -p "$FONT_DIR"
if [ -f "$FONT_FILE" ]; then
  echo "  La fuente ya existe, se omite descarga."
else
  wget -q "$NERD_FONT_URL" -O "$FONT_FILE"
  echo "  Fuente descargada."
fi
fc-cache -fv 2>/dev/null | tail -1
echo ""

# ──────────────────────────────────────────────
# 2. Symlinks
# ──────────────────────────────────────────────
echo "==> Creando enlaces simbólicos..."

link_file "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"
link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Neovim
link_file "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
link_file "$DOTFILES_DIR/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"

# Zellij
link_file "$DOTFILES_DIR/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"

echo ""
echo "Instalación completada."
