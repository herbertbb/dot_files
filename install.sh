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

echo "Instalando dotfiles desde: $DOTFILES_DIR"

link_file "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
link_file "$DOTFILES_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"

echo "Instalación completada."
