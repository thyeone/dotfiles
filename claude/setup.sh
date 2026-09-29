#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$DOTFILES_DIR/claude"
CLAUDE_CONFIG_DIR="$HOME/.claude"

echo "🤖 Setting up Claude Code configuration..."

mkdir -p "$CLAUDE_CONFIG_DIR"

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

if [ -f "$CLAUDE_DIR/statusline-command.sh" ]; then
  create_symlink "$CLAUDE_DIR/statusline-command.sh" "$CLAUDE_CONFIG_DIR/statusline-command.sh"
else
  echo "⚠️  statusline-command.sh not found at $CLAUDE_DIR/statusline-command.sh"
fi

echo "✅ Claude Code configuration setup completed!"
