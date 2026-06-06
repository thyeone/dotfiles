#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GHOSTTY_DIR="$DOTFILES_DIR/ghostty"
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"

echo "👻 Setting up Ghostty configuration..."

mkdir -p "$GHOSTTY_CONFIG_DIR"

create_symlink() {
  local source_file="$1"
  local target_file="$2"

  if [ -L "$target_file" ]; then
    echo "⚠️  Removing existing symlink: $target_file"
    rm "$target_file"
  elif [ -f "$target_file" ]; then
    echo "⚠️  Backing up existing file: $target_file -> ${target_file}.backup"
    mv "$target_file" "${target_file}.backup"
  fi

  echo "🔗 Creating symlink: $target_file -> $source_file"
  ln -s "$source_file" "$target_file"
}

if [ -f "$GHOSTTY_DIR/config" ]; then
  create_symlink "$GHOSTTY_DIR/config" "$GHOSTTY_CONFIG_DIR/config"
else
  echo "⚠️  config not found at $GHOSTTY_DIR/config"
fi

echo "✅ Ghostty configuration setup completed!"
